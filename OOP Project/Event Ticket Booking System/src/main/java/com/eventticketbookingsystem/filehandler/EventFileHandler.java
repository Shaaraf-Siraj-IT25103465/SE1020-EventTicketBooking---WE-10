package com.eventticketbookingsystem.filehandler;

import com.eventticketbookingsystem.model.Event;
import com.eventticketbookingsystem.repository.EventRepository;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class EventFileHandler implements EventRepository {

    private static final String FILE_PATH = "D:/Git repository/SE1020-EventTicketBooking---WE-10/OOP Project/Event Ticket Booking System/src/main/resources/events.xml";
    static {
        System.out.println("FILE PATH: " + FILE_PATH);
    }

    // CREATE
    @Override
    public void create(Event event) throws Exception {
        File file = new File(FILE_PATH);
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(file);

        Element root = doc.getDocumentElement();
        Element newEvent = doc.createElement("event");
        newEvent.appendChild(createEl(doc, "eventId",        event.getEventId()));
        newEvent.appendChild(createEl(doc, "eventName",           event.getEventName()));
        newEvent.appendChild(createEl(doc, "date",           event.getDate()));
        newEvent.appendChild(createEl(doc, "time", event.getTime()));
        newEvent.appendChild(createEl(doc, "venue",          event.getVenue()));
        newEvent.appendChild(createEl(doc, "category",       event.getCategory()));
        newEvent.appendChild(createEl(doc, "totalSeats",     String.valueOf(event.getTotalSeats())));
        newEvent.appendChild(createEl(doc, "availableSeats", String.valueOf(event.getAvailableSeats())));
        newEvent.appendChild(createEl(doc, "ticketPrice",    String.valueOf(event.getTicketPrice())));
        root.appendChild(newEvent);
        saveToFile(doc, file);
    }

    // READ
    @Override
    public List<Event> readAll() throws Exception {
        List<Event> events = new ArrayList<>();
        File file = new File(FILE_PATH);
        if (!file.exists()) return events;

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(file);
        doc.getDocumentElement().normalize();

        NodeList nodeList = doc.getElementsByTagName("event");
        for (int i = 0; i < nodeList.getLength(); i++) {
            Node node = nodeList.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                Element el = (Element) node;
                Event event = new Event();
                event.setEventId(getValue(el, "eventId"));
                event.setEventName(getValue(el, "eventName"));
                event.setDate(getValue(el, "date"));
                event.setTime(getValue(el, "time"));
                event.setVenue(getValue(el, "venue"));
                event.setCategory(getValue(el, "category"));
                event.setTotalSeats(Integer.parseInt(getValue(el, "totalSeats")));
                event.setAvailableSeats(Integer.parseInt(getValue(el, "availableSeats")));
                event.setTicketPrice(Double.parseDouble(getValue(el, "ticketPrice")));
                events.add(event);
            }
        }
        return events;
    }

    // UPDATE
    @Override
    public void update(Event updated) throws Exception {
        File file = new File(FILE_PATH);
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(file);

        NodeList nodeList = doc.getElementsByTagName("event");
        for (int i = 0; i < nodeList.getLength(); i++) {
            Element el = (Element) nodeList.item(i);
            if (getValue(el, "eventId").equals(updated.getEventId())) {
                el.getElementsByTagName("eventName").item(0).setTextContent(updated.getEventName());
                el.getElementsByTagName("date").item(0).setTextContent(updated.getDate());
                el.getElementsByTagName("time").item(0).setTextContent(updated.getTime());
                el.getElementsByTagName("venue").item(0).setTextContent(updated.getVenue());
                el.getElementsByTagName("category").item(0).setTextContent(updated.getCategory());
                el.getElementsByTagName("totalSeats").item(0).setTextContent(String.valueOf(updated.getTotalSeats()));
                el.getElementsByTagName("availableSeats").item(0).setTextContent(String.valueOf(updated.getAvailableSeats()));
                el.getElementsByTagName("ticketPrice").item(0).setTextContent(String.valueOf(updated.getTicketPrice()));
                break;
            }
        }
        saveToFile(doc, file);
    }

    // DELETE
    @Override
    public void delete(String eventId) throws Exception {
        File file = new File(FILE_PATH);
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(file);

        NodeList nodeList = doc.getElementsByTagName("event");
        for (int i = 0; i < nodeList.getLength(); i++) {
            Element el = (Element) nodeList.item(i);
            if (getValue(el, "eventId").equals(eventId)) {
                el.getParentNode().removeChild(el);
                break;
            }
        }
        saveToFile(doc, file);
    }

    // HELPERS
    private String getValue(Element el, String tag) {
        NodeList list = el.getElementsByTagName(tag);
        if (list.getLength() > 0) return list.item(0).getTextContent();
        return "";
    }

    private Element createEl(Document doc, String tag, String value) {
        Element el = doc.createElement(tag);
        el.setTextContent(value);
        return el;
    }

    private void saveToFile(Document doc, File file) throws Exception {
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        DOMSource source = new DOMSource(doc);
        StreamResult result = new StreamResult(file);
        transformer.transform(source, result);
    }
}
