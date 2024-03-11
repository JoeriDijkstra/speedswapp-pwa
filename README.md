# Speedswapp

Speedswapp was supposed to be a social media for car enthusiasts. This will no longer be the case due to Apple's decision to no longer support PWA's. Instead of just shutting it down I have decided to open source the code.

# Running it
You can run it via Phoenix with:
`docker-compose up`
`mix deps.get`
`mix phx.server`

And it should work. What won't work is uploading files, since it requires a S3 client with the secrets in the .env file.

# Contributing
There is still some work to be done. If you want to contribute, just follow the code guidelines used in the current codebase and shoot me an MR.

# To be done
- [ ] Configurable file storage, perhaps locally using minio in docker
- [ ] Add comments
- [ ] Add likes
- [ ] Add comments on comments
- [ ] Remove registration codes
- [ ] Add group chats
- [ ] Add realtime private chats
