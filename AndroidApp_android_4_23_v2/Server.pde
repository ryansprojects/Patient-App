// ************* HELPER CODE *************

/* code modified from:
  Based on: http://wiki.processing.org/index.php?title=Saving_files_to_a_web_server&oldid=482
  Updated on 04.07.2013 by Abe Pazos - http://funprogramming.org
*/

String SCRIPT_URL = "http://gregmicek.com/4012/prod/file-test/index.php";

void saveToWeb(String filename) {
  postData(filename, "text/plain", loadBytes(filename));
}

void postData(String filename, String ctype, byte[] bytes) {
  try {
    URL u = new URL(SCRIPT_URL);
    URLConnection c = u.openConnection();
    // post multipart data

    c.setDoOutput(true);
    c.setDoInput(true);
    c.setUseCaches(false);

    // set request headers
    c.setRequestProperty("Content-Type", "multipart/form-data; boundary=AXi93A");

    // open a stream which can write to the url
    DataOutputStream dstream = new DataOutputStream(c.getOutputStream());

    // write content to the server, begin with the tag that says a content element is coming
    dstream.writeBytes("--AXi93A\r\n");

    // describe the content
    dstream.writeBytes("Content-Disposition: form-data; name=p5uploader; filename=" + filename +
      " \r\nContent-Type: " + ctype +
      "\r\nContent-Transfer-Encoding: binary\r\n\r\n");
    dstream.write(bytes, 0, bytes.length);

    // close the multipart form request
    dstream.writeBytes("\r\n--AXi93A--\r\n\r\n");
    dstream.flush();
    dstream.close();

    // print the response
    try {
      BufferedReader in = new BufferedReader(new InputStreamReader(c.getInputStream()));
      String responseLine = in.readLine();
      while (responseLine != null) {
        println(responseLine);
        responseLine = in.readLine();
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}
