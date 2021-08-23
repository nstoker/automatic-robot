# frozen_string_literal: true

require 'dragonfly'

app = Dragonfly[:images]

app.configure_with :imagemagick
app.configure_with :rails

if Rails.env.production?
  app.configure do |c|
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
      bucket_name: ENV['S3_BUCKET'],
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    )
  end

  app.datastore.tap do |ds|
    ds.storage_headers = { 'x-amz-acl' => 'private' }

    # and force to new region
    ds.configure do |c|
      c.region = 'eu-west-1'                        # defaults to 'us-east-1'
    end

    ds.storage.instance_variable_get('@signer').instance_variable_set('@region', 'eu-west-1')
  end
end
