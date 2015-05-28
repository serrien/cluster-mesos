default['mesos'] = {}
default['docker']['insecure-registry'] = "192.168.33.201:5000"
default['mesos']['docker']['images'] = [{name: "gliderlabs/registrator",action: :pull_if_missing}]