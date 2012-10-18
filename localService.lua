--#!/c:/lua5.1/lua.exe
---
---This is a homework in Mobile Application course in CUHK, written by zhaowenlong----
---

function networkListener (event)

	if (event.isError) then

	   print("Network error - download failed" .. event.response)

       return
	else

	 --download

     --Check whether the file exists, if yes, remove it
     local path = system.pathForFile(  "pos.txt", system.DocumentsDirectory )
     local fhd = io.open( path )

	 if fhd then

         print( "File exists" )

	     fhd.close()

	  local results, reason = os.remove( path )

     end

	 network.download("http://www.cse.cuhk.edu.hk/~tklam/pos.txt","GET",networkListener,"pos.txt",system.DocumentsDirectory)


	  -- read the data file downloaded and parse it

	  local    MaxLongitude = 0
	  local      MaxLatitude = 0

	  local path = system.pathForFile("pos.txt", system.DocumentsDirectory)
      --local filename = "d:/Dropbox/workspace/mobileApp/locService/pos1.txt"

	   -- i is used to remember the user id
	   local i = 0
	 for  line in io.lines(filename)  do

        -- print("line:" ..line)

		local id,id1,name,name1,longitude,longitude1,latitude,latitude1= string.find(line, "([^%s]+)([^%s]+)([^%s]+)([^%s]+)([^%s]+)")

		 --local id,name,longitude,latitude = 1,"s0123456789",13, 0.598

         --print("id:" .. id .. ",name:" .. name .. ",longitude:" .. longitude .. ",latitude:" .. latitude)

         ----if the furthest user can be shown, all users can be shown
         ----get Maximum x, y coordinates and Minimum x, y coordinates
         longitude =tonumber(longitude)
		if math.abs(longitude) >= MaxLongitude then
			MaxLongitude = longitude
		end

         ----find the relative location
		local  RelativeLongitude = math.abs(MaxLongitude - longitude)
		--print("longitude:" .. longitude .. ",RelativeLongitude:" ..RelativeLongitude)

		latitude =tonumber(latitude)
		if math.abs(latitude) >= MaxLatitude then
			MaxLatitude = latitude
		end

		local RelativeLatitude = math.abs(MaxLatitude - latitude)
         --print("RelativeLongitude:" .. RelativeLongitude .. ",RelativeLatitude:" .. RelativeLatitude)

		----construct the data
		info[i + 1 ] = { id, name, RelativeLongitude, RelativeLatitude, longitude, latitude}
         i = i + 1

		 print("getid:" .. id .. ",RelativeLongitude:" .. RelativeLongitude .. ",RelativeLatitude:" .. RelativeLatitude)
	end

 -- end
end

function tapListener1(event)
         print("display the circles")
		 circle:removeEventListener( "tap", tapListener1 )

		 --addListener2 is used to remove the text on screen
		 timer:performWithDelay( 1, addListener2 )
		 return true
end



function tapListener2(event)
         print("remove the text on screen")

		if myText ~= nil then
          object:removeSelf()
         end

		 --The text will be displayed for 5 seconds, and removed
		 timer:performWithDelay( 5000, tapListener2 )


		 return true
end

function addListener1()
		circle:addEventListener("tap", tapListener1)

end

--addListener2 is used to remove the text on screen
function addListener2()

		 circle:addListener2("tap",tapListener2)

         --timer.performWithDelay( 1, addListener2 )
		 return true
end


-- construct the bounding box
function displayResult()

	--define the 1st as the user, who should be in the ceneter and be in red color
	-- which means that index of info is 1,so
	local id = tonumber(info[1][1])
	print(" 1st user's id:" ..id)

	local userxpos = display.contentWidth / 2
	local userypos = display.contentHeight / 2

	---- create a new circle
	circle = display.newCircle(userxpos,userypos,15)
	circle:setFillColor(255,0,0,255)
	local name=info[1][2]

	circle.name = display.newText(name,userxpos,userypos,native.systemFont,16)
	--circle.name.isVisible = false

	for index,value in ipairs(info) do

		if index ~= 1 then

			print("The other id:" .. id)

			local xpos = info[index][3]
			local ypos = info[index][4]
			local name = info[index][2]


			--print("xpos:" .. xpos .. ",ypos:" .. ypos .. ",name:" .. name)
			circle = display.newCircle (xpos,ypos,15)

			circle:setFillColor(0,0,255,255)
			circle.name = display.newText(name,xpos,ypos,native.systemFont,16)
			--circle.name.isVisible = false
			end
		end


     --if being tapped, the user name will be displayed
	 addListener1()

	-- display the text
	myText=display.newText("Successfully get data",25,25,native.systemFont,16)
	myText.x = display.contentWidth / 2
	myText.y = display.contentHeight / 16
	myText:setTextColor(255,255,255)
end


------ main ------
--
-- table info is used to store the user's information
info = {}

--get data every 10 seconds and construct the related user data
timer.performWithDelay(10000,networkListener,0)
--networkListener()
---info[1] = { 1, "s11222", 10, 10}

-- display the result on screen and interact with the user
displayResult()
