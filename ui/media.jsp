<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<script type="text/javascript">
  $(function() {
    $("#osmVideo").osmplayer({
      playlist: '/assets/osmplayer/playlist.xml',
      width: '100%'
    });
    
    $("#osmAudio").osmplayer({
        file: '/media/music/test.mp3',
        width: '100%',
        showController: 'true',
        controllerOnly: 'true'
      });
  });
</script>

<script type="text/javascript">
  $('#mediaTabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });
  
  $('#videoTabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });
</script>

<script type="text/javascript">
	function addVideo() {
		var video = 'media/webMethod/addTrack?p=' + getTitle() + '&p=' + getUrl() + '&p=' + getType();
		window.location.href = video;
		return false;
	};
	
	function getTitle() {
		return document.getElementById("videoTitle").value;
	};

	function getUrl() {
		return document.getElementById("videoUrl").value; 
	};
	
	function getType() {
		var radios = document.getElementsByName("optionsRadios");
		for (var i = 0; i < radios.length; i++) {       
		    if (radios[i].checked) {
		        return radios[i].value;
		    }
		}   
	};
</script>

<!--=============================================================-->
<section class="row-fluid">
	<ul id="mediaTabs" class="nav nav-tabs">
		<li class="active"><a href="#video" data-toggle="tab">Video</a></li>
	    <li><a href="#audio" data-toggle="tab">Audio</a></li>
	</ul>
	            
	<div id="mediaTabsContent" class="tab-content">
		
		<!-- Video Player -->
		<div class="tab-pane fade active in" id="video">
	
	    	<h1 class="lead">Video player</h1>
			<div id="osmVideo"></div>
			
			<!-- Button to trigger modals -->
			<div class="btn-centered pull-left">
				<a href="#playVideo" role="button" class="btn btn-large" data-toggle="modal">Play a video on remote device</a>
			</div>
			<div class="btn-group btn-centered pull-right">	
				<a href="#addVideo" role="button" class="btn btn-large" data-toggle="modal">Add a video to playlist</a>
				<a href="#deleteVideo" role="button" class="btn btn-large btn-danger" data-toggle="modal">Remove a video from playlist</a>
			</div>
				
			<div id="playVideo" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
				<div class="modal-header">
			    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			    	<h3 id="ModalLabel">Which video would you like to watch?</h3>
			  	</div>
			  	<div class="modal-body">
			  		<table class="table table-hover">
					  <thead>
					    <tr>
					      <th>#</th>
					      <th>Title</th>
					    </tr>
					  </thead>
					  <tbody>
					    <c:forEach var="track" items="${tracks}" varStatus="loop">
					    	<tr>
					    		<td>${loop.index}</td>
								<td><a href="media/webMethod/playTrack?p=${track}">${track}</a></td>
							</tr>
						</c:forEach>
					  </tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				</div>
			</div>
				
			<!-- Add Video -->
			<div id="addVideo" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
			  <div class="modal-header">
			    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			    <h3 id="ModalLabel">Which video are you looking to add?</h3>
			  </div>
				  
			  <div class="modal-body">   
			     <ul id="videoTabs" class="nav nav-tabs">
					<li class="active"><a href="#external" data-toggle="tab">External content</a></li>
				    <li><a href="#upload" data-toggle="tab">Upload video</a></li>
				 </ul>
				 
				 <div id="videoTabsContent" class="tab-content">
					 <div class="tab-pane fade in active" id="external">
						 <form class="form-horizontal" onSubmit="return addVideo()" action="">
						  <fieldset>
						    
						    <legend>Please fill the following:</legend>
						    
						    <div class="control-group">
						    	<label class="control-label" for="videoTitle">Title</label>
						    	<div class="controls">
						    		<input type="text" id="videoTitle" placeholder="Type title here...">
						    	</div>
						    </div>
							    
						    <div class="control-group">
						    	<label class="control-label" for="videoType">Type</label>
						    	<div class="controls" id="videoType">
							    	<label class="radio inline">
								  		<input type="radio" name="optionsRadios" id="optionsRadios1" value="Youtube" checked> Youtube
									</label>
									<label class="radio inline">
									  <input type="radio" name="optionsRadios" id="optionsRadios2" value="Vimeo"> Vimeo
									</label>
									<label class="radio inline">
									  <input type="radio" name="optionsRadios" id="optionsRadios3" value="HTML5"> HTML5
									</label>
								</div>
							</div>
									
							<div class="control-group">
							    <label class="control-label" for="videoUrl">URL</label>
							    <div class="controls">
								    <input type="text" id="videoUrl" placeholder="Type URL here...">
								    <span class="help-block"><em>e.g. http://www.youtube.com/watch?v=X5_MAxoYwsQ</em></span>
								</div>
							</div>   
							    
						    <div class="modal-footer">
						    	<button aria-hidden="true" type="submit" class="btn btn-primary">Add video</button>
						    	<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
						    </div>
						  </fieldset>
						</form>
					</div>
					
					<div class="tab-pane fade" id="upload">
				    	<form:form class="form-horizontal" modelAttribute="uploadItem" action="media/uploadFile" method="post" enctype="multipart/form-data">
				            <fieldset>
				                <legend>Upload fields:</legend>
					 
				                <div class="control-group">
				                    <form:label class="control-label" for="name" path="name">Title</form:label>
				                    <div class="controls">
					                   	<form:input path="name" placeholder="Type title here..."/>
				                    </div>
				                </div>
					 
				                <div class="control-group">
				                    <form:label class="control-label" for="fileData" path="fileData">File</form:label>
				                    <div class="controls">
				                   		<form:input path="fileData" type="file"/>
				                   	</div>
				                </div>
					 
				                <div class="modal-footer">
						    		<button aria-hidden="true" type="submit" class="btn btn-primary">Upload video</button>
								    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
								</div>
				            </fieldset>
				        </form:form>
					</div>
				</div>
			  </div>
			</div>
				 
			<!-- Delete Video -->
			<div id="deleteVideo" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
			  <div class="modal-header">
			    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			    <h3 id="ModalLabel">Select a video to remove</h3>
			  </div>
			  <div class="modal-body">
			     <table class="table table-hover">
				  <thead>
				    <tr>
				      <th>#</th>
				      <th>Title</th>
				    </tr>
				  </thead>
				  <tbody>
				    <c:forEach var="track" items="${tracks}" varStatus="loop">
				    	<tr>
				    		<td>${loop.index}</td>
							<td><a href="media/webMethod/removeTrack?p=${track}">${track}</a></td>
						</tr>
					</c:forEach>
				  </tbody>
				</table>
			  </div>
			  <div class="modal-footer">
			    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
			  </div>
			</div>
		</div>
		
		<!-- Audio Player -->
		<div class="tab-pane fade" id="audio">
	    	<h1 class="lead">Audio player</h1>
			<div id="osmAudio"></div>
		</div>
	</div>
</section>