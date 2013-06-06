package com.pi;

import java.io.File;
import java.net.URL;
import java.util.HashMap;

import javax.xml.namespace.QName;

import com.pi.ressources.XMLEditor;

import automation.api.AbstractApp;

public class MediaApp extends AbstractApp {

	private XMLEditor xml = new XMLEditor("/home/pi/FYP/apache-tomcat-7.0.35/webapps/assets/osmplayer/playlist.xml"); 
	
	@Override
	public void onStartup() {
		connectToRemoteDevice("http://192.168.0.234:8080/media-companion-1.0.0/MediaPlayer?wsdl", new QName("http://media.pi.com/", "MediaPlayerService"));
	}
	
	@Override
	public String getState() throws NoSuchMethodException {
		if (isDeviceAvailable()) {
			return "Volume: " + getVolume() + "; Track position: " + getTimePosition() + "/" + getTotalTime(); 
		} else {
			return "Media device unavailable!";
		}
	}

	@Override
	public String homeTile() throws NoSuchMethodException {
		if (isDeviceAvailable()) {
			return (String) device.invokeMethod("getPlayingFile");
		} else {
			return "Media device unavailable!";
		}
	}
	
	@Override
	public void uploadFile(String fileName, File file) {
		xml.addTrack(fileName, "http://www.stuart-holland.com:8080/uploads/" + file.getName(), "HTML5");
	}
	
	@Override
	public HashMap<String, Object> getModels() {
		HashMap<String, Object> models = new HashMap<String, Object>();
		models.put("tracks", xml.getTrackList());
		return models;
	}
	
	public void addTrack(String title, String location, String type) {
		xml.addTrack(title, location, type);
	}
	
	public void removeTrack(String id) {
		URL locationToRemove = xml.removeTrack(id);
		File fileToRemove = new File("/home/pi/FYP/apache-tomcat-7.0.35/webapps" + locationToRemove.getPath());
		if (fileToRemove.isFile()) {
			fileToRemove.delete();
		}
	}
	
	public void playTrack(String id) throws NoSuchMethodException {
		String fileToPlay = xml.getTrackLocation(id);
		fileToPlay = fileToPlay.replace(" ", "%20");
		Object parameters[] = {fileToPlay};
		if (isDeviceAvailable()) {
			device.invokeMethod("playTrack", parameters);
		}
	}
	
	public void togglePlay() throws NoSuchMethodException {
		if (isDeviceAvailable()) {
			device.invokeMethod("togglePlay");
		}
	}
	
	public void setVolume(float volume) throws NoSuchMethodException {
		Object parameters[] = {volume};
		if (isDeviceAvailable()) {
			device.invokeMethod("setVolume", parameters);
		}
	}
	
	public float getVolume() throws NoSuchMethodException {
		if (isDeviceAvailable()) {
			return (float) device.invokeMethod("getVolume");
		} else {
			return 0;
		}
	}
	
	public void setTimePosition(long seconds) throws NoSuchMethodException {
		Object parameters[] = {seconds};
		if (isDeviceAvailable()) {
			device.invokeMethod("setTimePosition", parameters);
		}
	}
	
	public long getTimePosition() throws NoSuchMethodException {
		if (isDeviceAvailable()) {
			return (long) device.invokeMethod("getTimePosition");
		}
		return 0;
	}
	
	public long getTotalTime() throws NoSuchMethodException {
		if (isDeviceAvailable()) {
			return (long) device.invokeMethod("getTotalTime");
		}
		return 0;
	}
	
	public void close() throws NoSuchMethodException {
		if (isDeviceAvailable()) {
			device.invokeMethod("close");
		}
	}
}
