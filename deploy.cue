package main


import (
	"dagger.io/dagger"
    "universe.dagger.io/alpha/kubernetes/kapp"
)

dagger.#Plan & {
	actions: {
		deploy: kapp.#Deploy & {
			app:        "demo-app"
			fs:         client.filesystem."./".read.contents
			kubeConfig: client.commands.kc.stdout
			file:       "./release/kubernetes-manifests.yaml"
			namespace:  "demo-app"
		}
		ls: kapp.#List & {
			fs:         client.filesystem."./".read.contents
			kubeConfig: client.commands.kc.stdout
			namespace:  "demo-app"
		}
		inspect: kapp.#Inspect & {
			app:        "demo-app"
			fs:         client.filesystem."./".read.contents
			kubeConfig: client.commands.kc.stdout
			namespace:  "demo-app"
		}
		delete: kapp.#Delete & {
			app:        "demo-app"
			fs:         client.filesystem."./".read.contents
			kubeConfig: client.commands.kc.stdout
			namespace:  "demo-app"
		}
	}

	client: {
		commands: kc: {
			name: "kubectl"
			args: ["config", "view", "--raw"]
			stdout: dagger.#Secret
		}
		filesystem: "./": read: {
			contents: dagger.#FS
			include: ["./release/kubernetes-manifests.yaml"]
		}
	}
}
