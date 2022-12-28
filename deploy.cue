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
			//kubeConfig: client.commands.kc.stdout
                        KubeCinfig: client.env.KUBE_CONFIG_NE
			file:       "./release/kubernetes-manifests.yaml"
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
		}
		delete: kapp.#Delete & {
			app:        "demo-app"
			fs:         client.filesystem."./".read.contents
			kubeConfig: client.commands.kc.stdout
		}
	}

	client: {
		//commands: kc: {
		//	name: "kubectl"
		//	args: ["config", "view", "--raw"]
		//	stdout: dagger.#Secret
		//}
                env: {
                  KUBE_CONFIG_NE: string
                  //KUBE_CONFIG_NE: dagger.#Secret
                }
		filesystem: "./": read: {
			contents: dagger.#FS
			include: ["./release/kubernetes-manifests.yaml"]
		}
	}
}
