# ImagesDisplay
<h3>ImagesDisplay</h3>
<p>ViewController has a tableView which displays the images in 3-column.<br/> ViewController implements the UISearchController to allow user to enter the search query, extension of this controller handles the start of fetching server for images when the user stops editing the text. <br/>Once user scrolls and reaches end of the page, new fetch call is made to get the next page results for the same query. This is handled in cellForRowAt, here if the exisiting count of images is done displaying we make a new page call.<br/>If all the pages are fetched, at the end of last page, a toast is display to indicate user about the query has no more results.</p>
<h3>ImageDetailCell</h3>
<p>ImageDetailCell is used to display 3 images in a row. This even has the function to download the image and store the image in ImageCache.</p>
<h3>ImageCaching</h3>
<p>ImageCaching is a Singleton class, which has all the ImageCache data, this is used to display of images from cache instead of downloading same image again and again.</p>
<p>For fetching of data from server, ImageDataSource is used, here we have two functions</p>
<ul>
  <li>fetchImages -> which fetch the images of given page number and searchQuery</li>
  <li>fetchMore -> this increments the page number value, used for pagination</li>
</ul>
<h3>ImageDataModel</h3>
<p>ImageDataModel is used to parse the data fetched from the server. This uses Codable and Decodable to parse the json. <br/><br/>
Test case for model parsing are present.</p>
