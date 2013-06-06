<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<style>
.padding {
	padding-top: 40px;
}
</style>

<script type="text/javascript">
$('#state').ready(function() {
	$.ajaxSetup({ cache: false }); // This part addresses an IE bug.  without it, IE will only load the first number and will never refresh
	setInterval(function() {
		$.ajax({
	        url: '/apps/media/getState.html',
	        success: function(data) {
	          $('#state').html(data);
	    	}
		});
	}, 3000); // the "1000" here refers to the time to refresh the div.  it is in milliseconds. 
});
</script>

<section class="row-fluid">
	
	<div class="pull-right" id="media-controls">
		<a href="webMethod/togglePlay" type="button" class="btn btn-large btn-success">Play/Pause</a>
		<a href="webMethod/close" type="button" class="btn btn-large btn-danger">Close player</a>
	</div>

	<div>
		<h1 class="lead">Remote video player</h1>
		<p>Current state: <span id="state"><i class="icon-spinner icon-spin"></i>Loading...</span></p>
	</div>
	
	<div id="media-tracks">
		<h3>Select a video to play</h3>
		<table class="table table-hover padding">
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
					<td><a href="webMethod/playTrack?p=${track}">${track}</a></td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</div>
	
	<div class="btn-centered pull-left">
		<a href="/apps/media" role="button" class="btn btn-large">Switch to web player</a>
	</div>
</section>