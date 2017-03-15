-- Data (string) to write
local saveData = "My app state data"

-- Path for the file to write
local path = system.pathForFile( "myfile.txt", system.DocumentsDirectory )

print(path)

-- Open the file handle
local file, errorString = io.open( path, "w" )

if not file then
    -- Error occurred; output the cause
    print( "File error: " .. errorString )
else
    -- Write data to file
    file:write( saveData )
    -- Close the file handle
    io.close( file )
end

file = nil

-- Open the file handle
local file, errorString = io.open( path, "r" )

if not file then
    -- Error occurred; output the cause
    print( "File error: " .. errorString )
else
    -- Output lines
    for line in file:lines() do
        print( line )
    end
    -- Close the file handle
    io.close( file )
end

file = nil