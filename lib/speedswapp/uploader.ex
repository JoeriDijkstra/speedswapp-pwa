defmodule Speedswapp.Uploader do
  @moduledoc false

  import Mogrify

  def do_upload(image_path, s3_path, convert_function \\ &compress/1) do
    converted_image = convert_function.(image_path)

    IO.inspect(converted_image)

    image = File.read!(converted_image.path)

    "speedswapp"
    |> ExAws.S3.put_object(s3_path, image, acl: :public_read)
    |> ExAws.request()

    {:postpone, "https://speedswapp.ams3.digitaloceanspaces.com/#{s3_path}"}
  end

  def to_thumbnail(image_path) do
    open(image_path)
    |> resize_to_limit("256x256")
    |> save
  end

  def compress(image_path) do
    open(image_path)
    |> resize_to_limit("1024x768")
    |> save
  end
end
