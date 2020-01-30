
<cfquery name="GetGenreTitles" datasource="cfTraining">
	select G.GenreID, G.Genre, T.TitleID as TitleTableTitleId, T.Title, TT.TitleID as TimeTitleId, TT.SuitableTime, TT.GenreID
	from Genre_Ref G, Title T
	left join Title_Time TT on TT.TitleID = T.TitleID
	where G.GenreID = T.GenreID
	order by G.Genre, T.Title, TT.TitleID
</cfquery>

<html>
	<head>
		<title>
			Hosgeldiniz
		</title>
		
			
		<script language="JavaScript">
			
			// For each genre, create an array to hold the titles.
			// Each genre array will be identified by an index
			<cfset counter = 0>
			<cfset counterForTime = 0>
			<cfset counterForTimeTitleId = 0>
			<cfset counterForGenreTitleId = 0>
			
			// burada group kullanarak database'den gelen data nın halihazırda Genre altında gruplanmasını sağladık.
			<cfoutput query="GetGenreTitles" group="Genre">
			
			<cfset counter = counter + 1>
			
			<cfset i = 0>
			
			// Create the array
			GenreArray#counter# = new Array();
						
			<cfoutput>
			
			<cfset i = i + 1>
			// Populate the array
			GenreArray#counter#[#i#] = "#Title#";
			// To use the other parameters in populateTime method, 
			// SuitableTime and TitleTableTitleId has been added.
			GenreArray#counter#[#i#]=[]
			// Populate the array
			for (var i = 0; i < 1; i++) {
				  GenreArray#counter#[#i#]=["#Title#","#TitleTableTitleId#","#SuitableTime#"]
				}
   		    
			</cfoutput>
			</cfoutput>
			<!--By using the group attribute of the cfoutput tag, an array will be created for each genre -->
			<cfoutput query="GetGenreTitles" group="TimeTitleId">
				
				<cfset counterForTime = counterForTime + 1>
				<cfset counterForTimeTitleId = counterForTimeTitleId + 1>
				<cfset counterForGenreTitleId = counterForGenreTitleId + 1>
				
				<cfset j = 0>
				// Create the array
				TimeArray#counterForTime# = new Array();
				TimeTitleIdArray#counterForTimeTitleId# = new Array();
				GenreTitleIdArray#counterForGenreTitleId# = new Array();
				
				<cfoutput>
					
					<cfset j = j + 1>
					// Populate the array
					TimeArray#counterForTime#[#j#] = "#SuitableTime#";
					TimeArray#counterForTime#[#j#] = [];
					
					for (var i = 0; i < 4; i++) {
						  TimeArray#counterForTime#[#j#]=["#SuitableTime#","#TimeTitleId#"]
					}
				
					TimeTitleIdArray#counterForTimeTitleId#[#j#] = "#TimeTitleId#";
					GenreTitleIdArray#counterForGenreTitleId#[#j#] = "#TitleTableTitleId#";
					
				</cfoutput>
			
			</cfoutput>
			<!-- make them global -->
			var uniqueItems = [];
			var titlesIdArray = [];
			
			// Function to populate the titles for the genre selected
			function populateTitles() {
			// Only process the function if the first item is not selected.
			var ThisGenre = document.VideoForm.GenreID.selectedIndex;
			console.log("GenreArray" + ThisGenre  + ".length")
			
			if (document.VideoForm.GenreID.selectedIndex != 0) {
			// Find the selected index for the genre
			var ThisGenre = document.VideoForm.GenreID.selectedIndex;
			// Set the length of the titles drop-down
			// equal to the length of the genre’s array.tamam
			
			<!--pass the title values to a single array to 
			remove duplicate values. 
			In titles.push method "[0]" means just take title values.-->
			var titles = [];
			for (i=1; i<eval("GenreArray" + ThisGenre + ".length"); i++) {
				
				titles.push(eval("GenreArray" + ThisGenre + "[i]" + "[0]")) 
				
			}
			<!-- add null value to be able to add select title string -->
	     	titles.splice(0, 0, "null");
			<!-- remove duplciate values -->
			uniqueItems = Array.from(new Set(titles));
			<!-- set the length of Title column beforehand -->
		    document.VideoForm.Title.length = eval(uniqueItems.length);
			<!-- reset the titleIdArray for every title pick up!-->
			titlesIdArray = [];
			<!--add the titlesIdArray to use in populateTime. it will match with GenreArray second index
			will get the timevalue to display in Time box. -->
			for (i=1; i<eval("GenreArray" + ThisGenre + ".length"); i++) {
				// ("GenreArray" + 2 + "[" + 1 + "]" + "[" + 1 + "]")
				titlesIdArray.push(eval("GenreArray" + ThisGenre + "[i]" + "[1]")) 
				
			}			
			
		    titlesIdArray.splice(0, 0, "null");
			
			var forLoopArray = uniqueArray1(titles);
			// Loop through the genre’s array and populate the title drop-down.
			for (i=0; i<eval(uniqueItems.length); i++) {
				
						document.VideoForm.Title[i].value =
						eval("uniqueItems" + "[i]");
						document.VideoForm.Title[i].text =
						eval("uniqueItems"+ "[i]");
					}
				}
			
			 document.VideoForm.Title[0].value = "";
			 document.VideoForm.Title[0].text = "Select Title";
			 document.VideoForm.Title[0].selected = true;
			 
			}
			function uniqueArray1( ar ) {
				  var j = {};
				
				  ar.forEach( function(v) {
				    j[v+ '::' + typeof v] = v;
				  });
				
				  return Object.keys(j).map(function(v){
				    return j[v];
				  });
			} 

			function onlyUnique(value, index, self) { 
				    return self.indexOf(value) === index;
			}
			
			function populateTime()
			{
				if(document.VideoForm.Title.selectedIndex != 0)
				{
					var counterForTime = 0;
					
					var thisTitle = document.VideoForm.Title.selectedIndex;
					var thisGenre = document.VideoForm.GenreID.selectedIndex;
					// we get the titleID of related to the title.
					var titleId =
						eval("titlesIdArray "+ "[" + thisTitle + "]");
					
					//we got to find time period related to the titleID
					var coor2 = ["", titleId];
					//control whether there is any matching with the titleId 
					var filledTimeArray = isItemInArray(eval("GenreArray" + thisGenre), coor2);
					var thisGenre = document.VideoForm.GenreID.selectedIndex;
					
					document.VideoForm.SuitableTime.length = eval(filledTimeArray.length);
				
					for (i=0; i<filledTimeArray.length; i++) {
						
						document.VideoForm.SuitableTime[i].value =
						filledTimeArray[i];
						document.VideoForm.SuitableTime[i].text =
						filledTimeArray[i];
					
				  }
				    document.VideoForm.SuitableTime[0].value = "";
					document.VideoForm.SuitableTime[0].text = "Select Time";
					document.VideoForm.SuitableTime[0].selected = true;
				}
			  }
			  
			  
			  function isItemInArray(array, item) {
			  	var timeArray = [];
			    timeArray.splice(0, 0, "null");
			  
					 for (var i = 1; i < array.length; i++) {
					
			 		   if (array[i][1] == item[0] || array[i][1] == item[1]) {
								            
								timeArray.push((array[i][2]));
							}
						}
						
					    return timeArray;
					}
			
		</script>
	</head>
	<body>
		<h1>
			Videos
		</h1>
		<form name="VideoForm">
			<table border="0">
				<tr>
					<td>
						<b>
							Genre
						</b>
					</td>
					<td>
						<b>
							Title
						</b>
					</td>
					<td>
						<b>
							Time
						</b>
					</td>
				</tr>
				<tr>
					<td>
						<select name="GenreID" onchange="populateTitles()">
							<option value="0">
							Select Genre
							<cfoutput query="GetGenreTitles" group="Genre">
								<option value="#GenreID#">#Genre#
							</cfoutput>
						</select>
					</td>
					<td>
						<select name="Title" size="1" onchange="populateTime()">
							<option value="0">
						</select>
					</td>
					<td>
						<select name="SuitableTime" size="1">
							<option value="0">
						</select>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>