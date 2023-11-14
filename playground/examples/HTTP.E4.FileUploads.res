// https://bun.sh/guides/http/file-uploads

let server = Bun.serve({
  port: 4000,
  fetch: async (req, _server) => {
    let url = req->Request.url->URL.make

    switch url->URL.pathname {
    | "/" => "index.html"->Bun.file->Response.makeFromFile
    | "/action" =>
      let formData = await req->Request.formData
      let _name = formData->FormData.get("name")
      let profilePicture = formData->FormData.get("profilePicture")
      switch profilePicture {
      | String(_) | Null => panic("Must upload a profile picture")
      | File(file) =>
        let _ = await Bun.Write.writeFileToPath(
          ~destinationPath="profilePicture.png",
          ~input=Bun.fileFromFile(file),
        )
        Response.make("Success")
      }
    | _ => Response.make("Not Found", ~options={status: 404})
    }
  },
})
