default['mesos'] = {}
default['docker']['insecure-registry'] = "192.168.33.201:5000"
default['mesos']['docker']['images'] = [{name: "boune/nginx", source: "/vagrant/docker/nginx-hello/", action: :build_if_missing},
                                        {name: "boune/nginxtodo", source: "/vagrant/docker/nginx-todo/", action: :build_if_missing},
                                        {name: "boune/todolist", source: "/vagrant/docker/todolist/", action: :build_if_missing},
                                        {name: "tutum/hello-world", action: :pull_if_missing},
                                        {name: "mongo", tag: "3.0.2", action: :pull_if_missing}]