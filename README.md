# everything but the kitcken sink - for getting small stuff done

This docker image is for prototyping on kubernetes, or for running simple, low replica count workloads simply. It favors simplicty and development velocity over efficiency.

The docker image is Ubuntu based, and has a lot of different utilities pre-installed.

The entrypoint will execute, in parallel, the below programs:

* the value of any environment variable prefixed with `COMMAND_` will be executed in a bash context
* the value of any environment variable prefixed with `EXECUTABLE_` will be written to disk and executed
* any file mounted anywhere under `/executables` will be executed

The container will exit when the first executable exits, propogating that process' exit code.

Also, prior to execution, any environment variable prefixed with `FILE_` will be writting to disk. For example, setting `FILE_file=echo Hello, World!` will result in a file called `file` with the content `echo Hello, World!`.

## Example use cases:

### simple exporter

export time elapsed since epoch in prometheus format:

    apiVersion: v1
    kind: Pod
    metadata:
      name: example
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8000"
        prometheus.io/path: "/"
    spec:
      containers:
      - image: docker.io/eyalfirst/everything-but-the-kitchen-sink:latest
        env:
          - name: FILE_expose
            value: |
	      #! /bin/bash
	      echo time_since_epoch $(date "+%s")
          - name: COMMAND_server
	    value: shell2http --port 8000 /metrics ./expose
        resources:
          requests:
            cpu: "10m"
            memory: 128Mi
          limits:
            cpu: "500m"
            memory: 512Mi
        readinessProbe:
          httpGet:
            path: /
            port: 8000
          initialDelaySeconds: 5
        livenessProbe:
          httpGet:
            path: /
            port: 8000
