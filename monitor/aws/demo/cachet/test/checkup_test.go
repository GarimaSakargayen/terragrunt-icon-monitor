package test

import (
	"crypto/tls"
	"fmt"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"strings"
	"time"
	"io/ioutil"
	"log"
	"os"
	"path"
	"testing"
)

func TestInstanceStore(t *testing.T) {
	t.Parallel()

	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/defaults")

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)
		terraform.Destroy(t, terraformOptions)

		keyPair := test_structure.LoadEc2KeyPair(t, exampleFolder)
		aws.DeleteEC2KeyPair(t, keyPair)
	})

	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions, keyPair := configureTerraformOptions(t, exampleFolder)
		test_structure.SaveTerraformOptions(t, exampleFolder, terraformOptions)
		test_structure.SaveEc2KeyPair(t, exampleFolder, keyPair)

		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)
		testCheckup(t, terraformOptions)

	})
}

func configureTerraformOptions(t *testing.T, exampleFolder string) (*terraform.Options, *aws.Ec2Keypair) {
	uniqueID := random.UniqueId()
	awsRegion := "us-east-1"

	keyPairName := fmt.Sprintf("terratest-ssh-example-%s", uniqueID)
	keyPair := aws.CreateAndImportEC2KeyPair(t, awsRegion, keyPairName)

	privateKeyPath := path.Join(exampleFolder, "id_rsa_test")

	err := ioutil.WriteFile(privateKeyPath, []byte(keyPair.PrivateKey), 0644)
	if err != nil {
		panic(err)
	}

	err = os.Chmod(privateKeyPath, 0600)
	if err != nil {
		log.Println(err)
	}

	terraformOptions := &terraform.Options{
		TerraformDir:      exampleFolder,
		OutputMaxLineSize: 1024 * 1024,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"aws_region":       awsRegion,
			"public_key":  keyPair.PublicKey,
			"private_key_path": privateKeyPath,
		},
	}

	return terraformOptions, keyPair
}

func testCheckup(t *testing.T, terraformOptions *terraform.Options) {
	tlsConfig := tls.Config{}

	maxRetries := 30
	timeBetweenRetries := 5 * time.Second
	publicIP := terraform.Output(t, terraformOptions, "public_ip")

	instanceText


	http_helper.HttpGetWithRetry(t, publicIP, &tlsConfig, 200, instanceText, maxRetries, timeBetweenRetries)
}
