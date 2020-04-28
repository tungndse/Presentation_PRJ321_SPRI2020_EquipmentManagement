package controllers.equipment;

import managers.EquipmentManager;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

@WebServlet("/EquipmentImageController")
public class EquipmentImageController extends HttpServlet {

    private static final String ERROR = "admin-mng-equipment.jsp";
    private static final String SUCCESS_FROM_INSERT = "admin-mng-equipment.jsp";
    private static final String SUCCESS_FROM_UPDATE = "EquipmentLoadController";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;

        File fileLive;
        File fileResource;
        File fileLarge;

        int maxFileSize = 5000 * 1024;

        try {
            String filePathLive =
                    "/Users/tungnd/Documents/U_Progression/Spring 2020/PRJ321_1/Presentation/Presentation_SPRI2020_EquipmentManagement/out/artifacts/Presentation_SPRI2020_EquipmentManagement_war_exploded/equipment-images/";

            String filePathResource =
                    "/Users/tungnd/Documents/U_Progression/Spring 2020/PRJ321_1/Presentation/Presentation_SPRI2020_EquipmentManagement/web/equipment-images/";

            String filePathForLargeSize =
                    "/Users/tungnd/Documents/U_Progression/Spring 2020/PRJ321_1/Presentation/Presentation_SPRI2020_EquipmentManagement/out/production/Presentation_SPRI2020_EquipmentManagement/";
            //Verify the content type
            String contentType = request.getContentType();

            if (contentType.contains("multipart/form-data")) {
                DiskFileItemFactory factory = new DiskFileItemFactory();
                //maximum size that will be stored in memory
                factory.setSizeThreshold(maxFileSize);

                //Create a new file to upload handler
                ServletFileUpload upload = new ServletFileUpload(factory);

                //maximum file size to be uploaded
                upload.setSizeMax(maxFileSize);


                //Parse the request to get file items
                List<FileItem> fileItems = upload.parseRequest(request);

                // Process the uploaded file items
                // Order of input fields on form must be valid

                Iterator<FileItem> fileListIterator = fileItems.iterator();

                // Get equipment ID
                FileItem equipmentIdFileItem = fileListIterator.next();

                String equipmentId = equipmentIdFileItem.getString();

                // Get file data
                FileItem imageFileItem = fileListIterator.next();

                String filename = imageFileItem.getName();

                String extension = "jpg";
                int i = filename.lastIndexOf('.');
                if (i > 0) { //---------------------------
                    extension = filename.substring(i + 1);
                }

                // Write file into deployment war live
                fileLive = new File(filePathLive + equipmentId + "." + extension);

                imageFileItem.write(fileLive);

                // Write file into resource so each time application run again it load from this into WAR,
                // Also when changing image on details (live), it update both from live root and resource root
                fileResource = new File(filePathResource + equipmentId + "." + extension);

                imageFileItem.write(fileResource);

                fileLarge = new File(filePathForLargeSize + equipmentId + "." + extension);

                imageFileItem.write(fileLarge);

                String simpleImgPath = "/equipment-images/" + equipmentId + "." + extension;

                String fromInsert = null;
                if (fileListIterator.hasNext()) {
                    FileItem flagFromInsert = fileListIterator.next();
                    fromInsert = flagFromInsert.getString();
                }

                System.out.println(equipmentId);
                System.out.println(fromInsert);

                // NOW update image path on database
                EquipmentManager equipmentManager = new EquipmentManager();
                boolean success = equipmentManager.updateEquipmentImage(equipmentId, simpleImgPath);

                // finally return to Equipment Load Controller and load equipment details using passed attribute
                if (success) {
                    request.setAttribute("EID", equipmentId);
                    url = fromInsert != null ? SUCCESS_FROM_INSERT : SUCCESS_FROM_UPDATE;
                }
            }

        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            System.out.println("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);

    }


}
