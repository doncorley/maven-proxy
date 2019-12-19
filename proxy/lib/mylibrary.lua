M = {}

-- If the incoming request is a snapshot, return the latest snapshot resource
function M.handleRequest(request_handle)
  local path = request_handle:headers():get(":path")
  if M.isSnapshot(path) then
    print("Is Snapshot - Path=" .. path)
    M.requestAlternatePage(request_handle)
  end

end

-- No functionality currently - May be nice to do only do the snapshot retrieval on a 404
function M.handleResponse(response_handle)

end

-- Read the actual resource for this maven snapshot request
function M.requestAlternatePage(request_handle)

  local path = request_handle:headers():get(":path")
  local metadataPath = M.getMetadataPath(path)
  print("MetadataPath=" .. metadataPath)

  local authority = request_handle:headers():get(":authority")
  local headers, body = request_handle:httpCall(
  "nexus_service",
  {
    [":method"] = "GET",
    [":path"] = metadataPath,
    [":authority"] = authority
  },
  "",
  5000)

  local extension = string.sub(path, -3)
  for i = string.len(body), 1, -1 do
    if string.sub(path, i, i) == "." then
        extension = string.sub(path, i+1)
        for j = i-10, 1, -1 do
            if string.sub(path, j, j) == "-" then
                path = string.sub(path, 1, j)
                break
                end
        end
        break
    end
  end
  local tags = "<extension>" .. extension .. "</extension>"
  local start = string.find(body, tags, 1, true)
  start = string.find(body, "<value>", start)
  local last = string.find(body, "</value>", start)
  local tag = string.sub(body, start+7, last-1)
  path = path .. tag .. "." .. extension

  print("Corrected Path=" .. path)
  request_handle:headers():replace(":path", path)

end

-- From the path, get the metadata path
function M.getMetadataPath(path)

    start = string.find(path, "%-SNAPSHOT/")
    path = string.sub(path, 1, start + 9)

    path = path .. "maven-metadata.xml"

    return path

end

-- Is this path a snapshot?
function M.isSnapshot(path)

    return path ~= nil and string.find(path, "%-SNAPSHOT/") ~= nil and string.find(path, "%-SNAPSHOT%.") ~= nil

end

return M
