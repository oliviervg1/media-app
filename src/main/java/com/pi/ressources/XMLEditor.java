package com.pi.ressources;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.Namespace;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;
 
public class XMLEditor {

	private String file;
	private SAXBuilder builder;
	private XMLOutputter xmlOutput;
	private Document doc;

	public XMLEditor(String file) {
		this.file = file;
		builder = new SAXBuilder();
		xmlOutput = new XMLOutputter();
		xmlOutput.setFormat(Format.getPrettyFormat());
		doc = null;
	}
	
	private void loadXML() {
		File xmlFile = new File(file); 
		try {
			doc = (Document) builder.build(xmlFile);
		} catch (JDOMException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void outputXML() {
		try {
			xmlOutput.output(doc, new FileWriter(file));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public ArrayList<String> getTrackList() {
		loadXML();
		Element rootNode = doc.getRootElement();
		Namespace ns = rootNode.getNamespace();
		Element trackList = rootNode.getChild("trackList", ns);
		
		ArrayList<String> trackNames = new ArrayList<String>();
		for (Element track : trackList.getChildren()) {
			trackNames.add(track.getAttributeValue("id"));
		}
		
		return trackNames;
	}
	
	public String getTrackLocation(String trackId) {
		loadXML();
		Element rootNode = doc.getRootElement();
		Namespace ns = rootNode.getNamespace();
		Element trackList = rootNode.getChild("trackList", ns);
		
		for (Element track : trackList.getChildren()) {
			if (track.getAttribute("id").getValue().equalsIgnoreCase(trackId)) {
				return track.getChild("location", ns).getText();
			}
		}
		
		return null;
	}
	
	public void addTrack(String title, String location, String type) {
		loadXML();
		Element rootNode = doc.getRootElement();
		Namespace ns = rootNode.getNamespace();
		Element trackList = rootNode.getChild("trackList", ns);
		
		Element elementToAdd = new Element("track", ns);
		elementToAdd.setAttribute("id", title);
		elementToAdd.addContent(new Element("title", ns).setText(type + ": " + title));
		elementToAdd.addContent(new Element("location", ns).setText(location));
			
		trackList.addContent(elementToAdd);
		outputXML();
	}
	
	public URL removeTrack(String id) {
		loadXML();
		Element rootNode = doc.getRootElement();
		Namespace ns = rootNode.getNamespace();
		Element trackList = rootNode.getChild("trackList", ns);
		
		// Get list of tracks
		List<Element> tracks = trackList.getChildren();
		
		// Removing elements
		Element elementToRemove = null;
			
		for (Element element : tracks) {
			if(element.getAttribute("id").getValue().equalsIgnoreCase(id)) {
				elementToRemove = element;
			}
		}
		
		URL filepathToDelete = null;
		try {
			filepathToDelete = new URL(elementToRemove.getChild("location", ns).getValue());
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
		trackList.removeContent(elementToRemove);
		outputXML();
		
		return filepathToDelete;
	}
}
