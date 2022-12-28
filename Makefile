.PHONY: build

build:
	sam build

deploy-infra:
	sam build && aws-vault exec lyle --no-session -- sam deploy 

deploy-site:
	aws-vault exec lyle --no-session -- aws s3 sync ./website s3://lyles-resume-challenge