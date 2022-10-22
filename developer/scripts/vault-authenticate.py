import os
import hvac

def vaultAuthenticate(vaultClientToken=None):

    vaultClient= hvac.Client(url= "http://127.0.0.1:8200", token= vaultClientToken)

    if(vaultClientToken == None):
        githubAccessToken= open("./developer/credentials/github/access_token", "r").read( )

        loginResponse= vaultClient.auth.github.login(token= githubAccessToken)
        vaultClientToken= loginResponse["auth"]["client_token"]

        open("./developer/credentials/vault/client_token", "w+").write(vaultClientToken)

    awsCredentials= vaultClient.secrets.aws.generate_credentials(name= "project_admin")

    awsAccessKey= awsCredentials["data"]["access_key"]
    awsSecretKey= awsCredentials["data"]["secret_key"]

    #* for development workspace
    open("./developer/credentials/aws/access_key", "w+").write(awsAccessKey)
    open("./developer/credentials/aws/secret_key", "w+").write(awsSecretKey)

    #* for testing workspace
    open("./developer/envs/aws.credentials.env", "w+").write(
        f"aws_access_key_id={awsAccessKey}\naws_secret_access_key={awsSecretKey}"
    )

requiredDirectories= [ "aws", "vault" ]

for directory in requiredDirectories:
    directorPath= f"./developer/credentials/{directory}"

    if not os.path.exists(directorPath):
        os.makedirs(directorPath)

if not os.path.exists("./developer/envs"):
    os.makedirs("./developer/envs")

try:
    vaultAuthenticate(
        vaultClientToken= open("./developer/credentials/vault/client_token", "r").read( )
    )
except:
    vaultAuthenticate( )