package gardncl.whobrokeitlast.services;

import com.google.appengine.repackaged.com.google.gson.JsonElement;
import com.google.appengine.repackaged.com.google.gson.JsonObject;
import gardncl.whobrokeitlast.dao.BreakDao;
import gardncl.whobrokeitlast.dao.DeveloperDao;
import gardncl.whobrokeitlast.dao.ProjectDao;
import gardncl.whobrokeitlast.dto.BreakDto;
import gardncl.whobrokeitlast.models.Break;
import gardncl.whobrokeitlast.models.Developer;
import gardncl.whobrokeitlast.models.Project;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;

import java.util.Date;
import java.util.NoSuchElementException;

@Service
public class TravisParseService {

    @Autowired
    private PercentEncodingParseService parseService;

    @Autowired
    private BrokenBuildService brokenBuildService;

    /**
     * Parses webhook from Travis-CI and determines if the build has broken.
     * If the build has broken it will be added to the broken build table,
     * the user will have their number of builds incremented by one, and
     * their last build break updated. Users that were not already in the
     * database will be added.
     * @param body is the webhook data from Travis-CI
     * @return status message
     */
    //TODO: TAKE INPUT AS STRING INSTEAD OF MULTIVALUEMAP
    public String processRequest(MultiValueMap<String, String> body) {

        //CONVERT STRING FROM PERCENT ENCODING TO JSON OBJECT
        JsonObject json = parseService
                .percentEncodingToJson(body.getFirst("payload"))
                .getAsJsonObject();

        //COLLECT DATA REQUIRED TO MAKE ENTRY IN DATABASE
        JsonElement repository = json.get("repository");
        JsonElement matrix = json.get("matrix").getAsJsonArray().get(0);
        JsonElement state = json.get("state");
        String userName = getEntry(matrix, "author_name");
        String committerName = getEntry(matrix, "committer_name");
        String projectTitle = getEntry(repository, "name");

        //DETERMINE IF THE BUILD BROKE
        boolean brokenBuild = state.toString().contains("errored");
        String response = "Build passed.";

        if (brokenBuild) {
            BreakDto breakDto = new BreakDto(userName,projectTitle,committerName,getEntry(matrix, "author_email"));
            brokenBuildService.saveBreak(breakDto);

            //GENERATE BROKEN BUILD RESPONSE
            response = (projectTitle + " was broken by ") + userName;
        }


        return response;
    }

    /**
     * Gets value from JSON object according to specified key.
     * @param element
     * @param key
     * @return
     */
    private String getEntry(JsonElement element, String key) {
        return trim(element.getAsJsonObject().get(key).toString());
    }

    /**
     * Removes extraneous quotes that remain from percent encoding to
     * JSON transformation.
     * @param input
     * @return String without extra quotes.
     */
    private String trim(String input) {
        return input.substring(1,input.length()-1);
    }

}
