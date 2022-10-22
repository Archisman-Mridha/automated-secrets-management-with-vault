start-vault-server:
	vault server -dev -tls-skip-verify -dev-listen-address=127.0.0.1:8200 -address=http://127.0.0.1:8200

login-to-vault:
	vault login -method=github -path=github token=

generate-aws-credentials:
	vault read aws/creds/project_admin

vault-authenticate:
	python ./developer/scripts/vault-authenticate.py