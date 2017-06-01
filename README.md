# xserver-travis

Docker image data for the X.Org X Server's Travis CI.

This build includes all of the dependencies of the X Server build as
well as the testing infrastructure, to minimize the time spent per
Travis build of the X Server.

The X Server's .travis.yml will generate its own Dockerfile that will
pull from one of the images generated using this repository, and
request that the current code that Travis is testing be added to the
image as well.

The workflow for updating the Travis docker image is:

    # Generate a new build called "xserver-travis"
    sudo docker build -t xserver-travis .

    # Tag it and upload it to your dockerhub.
    #
    # We use versioned tags so that you can do updates in lockstep of
    # the image and the X Server's .travis.yml.
    sudo docker tag xserver-travis username/xserver-travis:v3
    sudo docker push anholt/xserver-travis:v3

    cd ../xserver
    git checkout -b travis-ci-test
    emacs .travis.yml
    # Change "anholt/xserver-travis:v3" to your repository and tag
    git commit -a -m "Test out my new Travis Docker image"
    git push username travis-ci-test
