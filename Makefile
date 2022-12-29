.PHONY: build

build:
	sam build

deploy-infra:
	sam build && aws-vault exec lyle --no-session -- sam deploy 

deploy-site:
	aws-vault exec lyle --no-session -- aws s3 sync ./website s3://lyles-resume-challenge


deploy-app:
	aws-vault exec lyle --no-session -- aws s3 sync ./counter-app s3://lyles-resume-challenge/counter-app

deploy-all:
	sam build && aws-vault exec lyle --no-session -- sam deploy && aws-vault exec lyle --no-session -- aws s3 sync ./counter-app s3://lyles-resume-challenge/counter-app