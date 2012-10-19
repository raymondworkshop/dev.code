--#!/c:/lua5.1/lua.exe
---
---This is a homework in Mobile Application course in CUHK, written by zhaowenlong----
---The function is to display all users's location based on user's location on screen ----
---It is built on Corona middle layer

function networkListener ()

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

		local  MaxLongitude,MaxLatitude = 0,0
		local userLongitude,userlatitude,relativeLongitude,relativeLatitude = 0, 0, 0, 0

		local path = system.pathForFile("pos.txt", system.DocumentsDirectory)
          --  local filename = "d:/Dropbox/workspace/mobileApp/locService/pos.txt"

		-- i is used to remember the user id
		local i = 0

		for  line in io.lines(filename)  do

			i = i + 1
			--print("line:" ..line)
		    local _,_,id,name,longitude,latitude,altitude= string.find(line, '(%d+)%s+(%w+)%s+([-+]*[0-9]\.?[0-9]*)%s+([-+]*[0-9]\.?[0-9]*)%s+([^%s]+)')
			 --local id,name,longitude,latitude = 1,"s0123456789",13, 0.598

             --print("id:" .. id .. ",name:" .. name .. ",longitude:" .. longitude .. ",latitude:" .. latitude)

             --construct the Bounding box based on maximum and Minimum
             ----which means that if the furthest user can be shown, all users can be shown
             ----get Maximum x, y coordinates and Minimum x, y coordinates
            longitude =tonumber(longitude)
		    if math.abs(longitude) >= MaxLongitude then
			     MaxLongitude = math.abs(longitude)
		    end

		     --print("longitude:" .. longitude .. ",MaxLongitude:" ..MaxLongitude)

		    latitude =tonumber(latitude)
		    if math.abs(latitude) >= MaxLatitude then
		         MaxLatitude = math.abs(latitude)
		    end
             --print("latitude:" .. latitude .. ",MaxLatitude:" ..MaxLatitude)


			 ----find the relative location

			 if i == 1 then
                 userLongitude = longitude
                 userlatitude = latitude

				 relativeLongitude = longitude
				 relativeLatitude = latitude
			 else
			     relativeLongitude = longitude - userLongitude
				 relativeLatitude = latitude - userlatitude
             end

		     ----construct the data
			 id=tonumber(id)
		    userinfo[i] = { id, name,latitude, longitude,relativeLatitude,relativeLongitude}

		    print("getid:" .. id .. ",name:" .. name .. ",longitude:" .. longitude .. ",latitude:" .. latitude)
            --print("relativeLatitude:" .. relativeLatitude .. ",relativeLongitude:" .. relativeLongitude)
		 end

	 --print("MaxLongitude:" .. MaxLongitude .. ",MaxLatitude:" .. MaxLatitude)

		 -- store the max info in table configinfo
	 configinfo ={MaxLatitude,MaxLongitude}

    --end

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

		if circle.name ~= nil then
          circle.name.isVisible = false
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
	-- which means that index of userinfo is 1,so
	local id = userinfo[1][1]
	--print(" 1st user's id:" ..id)

	local defaultxpos = display.contentWidth / 2
	local defaultypos = display.contentHeight / 2
     --local defaultxpos = 20
	 --local defaultypos = 20

	 -- get the max display value on screen
	local displayLatitude = configinfo[1] * 2
	local displayLongitude= configinfo[2] * 2

	 -- user relative physical coordinates on screen
	local userxpos, userypos


	for index,value in ipairs(userinfo) do
        --print("index:" .. index)

		local id,name,latitude,longitude = userinfo[index][1],userinfo[index][2],userinfo[index][3],userinfo[index][4]
        local relativeLatitude,relativeLongitude = userinfo[index][5],userinfo[index][6]

		--calculate the relative physical coordinates and map the physical coordinates to display coordinates (320 x 480)

		--print("relativeLatitude:" ..relativeLatitude .. ",relativeLongitude:" ..relativeLongitude)
		if relativeLatitude>=0 then

			 userxpos = defaultxpos + (latitude * screenWidth) / displayLatitude

		else
			 userxpos = defaultxpos - (math.abs(latitude) * screenWidth) / displayLatitude

		end


         if relativeLongitude>=0 then
			userypos =  defaultypos + (longitude * screenHeight) / displayLongitude
		 else

			userypos =  defaultypos - (math.abs(longitude) * screenHeight) / displayLongitude
         end

		 print("id:" .. id .. ",userxpos:" .. userxpos .. ",userypos:" .. userypos)

		 ---- create a new circle
		 circle = display.newCircle(userxpos,userypos,15)

		if index == 1 then
            -- print("The user's id:" .. id)

	         circle:setFillColor(255,0,0,255)

		else

			--print("The other users' id:" .. id)

			circle:setFillColor(0,0,255,255)

		end

		circle.name = display.newText(name,userxpos,userypos,native.systemFont,16)
		--circle.name.isVisible = false

	end


     --if being tapped, the user name will be displayed
	 addListener1()

	-- display the text
	myText=display.newText("Successfully get data",defaultxpos,defaultypos - 60,native.systemFont,16)
	myText.x = display.contentWidth / 2
	myText.y = display.contentHeight / 16
	myText:setTextColor(255,255,255)
end


------ main ------

-- variable
---- table userinfo is used to store the user's information like id, name,RelativeLongitude, RelativeLatitude,longitude,latitude
userinfo = {}

---- table configinfo is used to store the current display information like screen resolution, Max Latitude , Max Longitude
configinfo = {}

---- the screen resolution
---- It is better to define a configuration file
screenWidth,screenHeight =320,480


--get data every 10 seconds and construct the related user data
timer.performWithDelay(10000,networkListener,0)
--networkListener()
--userinfo[1] = { 1, "s11222", 10, 10}

-- display the result on screen and interact with the user
displayResult()
