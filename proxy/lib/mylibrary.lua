M = {}

function M.foobar()

    print("In foobar-----------------")

    return "bar"
end

function M.crunchIn(request_handle)
  print("01")
  request_handle:headers():add("foo", M.foobar())
  for key, value in pairs(request_handle:headers()) do
    print("headers1 key=" .. key .. " value=" .. value)
  end
--  print("body=" .. request_handle:body())
  local path = request_handle:headers():get(":path")
  print("headers1 xpath1=" .. path)
  if M.isSnapshot(path) then
    print("isSnapshot " .. path)
    M.getAlternatePage(request_handle)
  end

end

function M.crunchOut(response_handle)
  print("02")
  local headers = response_handle:headers()
  for key, value in pairs(headers) do
    print("return headers2 key=" .. key .. " value=" .. value)
  end

  body_size = response_handle:body():length()
  response_handle:headers():add("response-body-size", tostring(body_size))
end

-- Read the alternate page for this request
function M.getAlternatePage(request_handle)

  local path = request_handle:headers():get(":path")
  local metadataPath = M.getMetadataPath(path)

  local headers, body = request_handle:httpCall(
  "web_service",
  {
    [":method"] = "GET",
    [":path"] = metadataPath,
    [":authority"] = "web_service"
  },
  "",
  5000)
  for key, value in pairs(headers) do
    print("return headers3 key=" .. key .. " value=" .. value)
  end
  print("body3=" .. body)

  request_handle:headers():replace(":path", "/headers")

end

-- From the path, get the metadata path
function M.getMetadataPath(path)

    path = "/headers"
    return path

end

-- Is this path pointing to a snapshot resource?
function M.isSnapshot(path)
    print("path3=" .. path)
    if (path == nil) then
        return false
    end

    if path == "/headers" or path == "/status/404" then
        return true
    else
        return false
    end

end

return M
