def label = "omisego-${UUID.randomUUID().toString()}"

podTemplate(
    label: label,
    containers: [
        containerTemplate(
            name: 'jnlp',
            image: 'omisegoimages/blockchain-base:1.6-otp20-stretch',
            args: '${computer.jnlpmac} ${computer.name}',
            alwaysPullImage: true,
            resourceRequestCpu: '1750m',
            resourceLimitCpu: '2000m',
            resourceRequestMemory: '2048Mi',
            resourceLimitMemory: '2048Mi'
        ),
    ],
) {
    node(label) {
        stage('Checkout') {
            checkout scm
        }

        stage('Build') {
            sh("mix do local.hex --force, local.rebar --force")
            withEnv(["MIX_ENV=test"]) {
                sh("mix do deps.get, deps.compile, compile")
            }
        }

        stage('Build Contracts') {
            withEnv(["SOLC_BINARY=/home/jenkins/.py-solc/solc-v0.4.18/bin/solc"]) {
                dir("populus") {
                    sh("pip install -r requirements.txt && python -m solc.install v0.4.18 && populus compile")
                }
            }
        }

        stage('Integration test') {
           sh("echo \"use Mix.Config; config :logger, level: :debug\" > tmpconfig")
           withEnv(["MIX_ENV=test", "SHELL=/bin/bash"]) {
               sh("mix do loadconfig tmpconfig, test --no-start --only integration")
           }
        }

        stage('Unit test') {
            withEnv(["MIX_ENV=test"]) {
                sh("mix coveralls.html --no-start --umbrella")
            }
        }

        stage('Cleanbuild') {
            withEnv(["MIX_ENV=test"]) {
                sh("mix do compile --warnings-as-errors --force, test --no-start --exclude test")
            }
        }

        stage('Dialyze') {
            sh("mix dialyzer --halt-exit-status")
        }

        stage('Lint') {
            withEnv(["MIX_ENV=test"]) {
                sh("mix do credo, format --check-formatted --dry-run")
            }
        }

    }
}
