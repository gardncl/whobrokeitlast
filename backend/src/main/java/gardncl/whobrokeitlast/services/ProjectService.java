package gardncl.whobrokeitlast.services;

import gardncl.whobrokeitlast.dao.DeveloperDao;
import gardncl.whobrokeitlast.dao.ProjectDao;
import gardncl.whobrokeitlast.models.Developer;
import gardncl.whobrokeitlast.models.Project;
import org.eclipse.egit.github.core.Repository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.NoSuchElementException;
import java.util.Optional;

@Service
public class ProjectService {

    @Autowired
    private ProjectDao projectDao;

    @Autowired
    private DeveloperDao developerDao;

    @Autowired
    private GithubService githubService;

    public Project insertProject(String projectTitle, String owner) throws IOException {

        Optional<Long> id = githubService.getRepos(owner)
                .stream()
                .filter(x -> x.getName().equals(projectTitle))
                .map(Repository::getId)
                .findFirst();

        if (!id.isPresent())
            throw new NoSuchElementException("Project "+projectTitle+" does not exist for user "+owner+".");

        Developer projectOwner = developerDao.getByUserName(owner);

        if (projectOwner == null)
            throw new NoSuchElementException("User "+owner+" does not exist.");

        Project project = new Project(id.get(), projectTitle, projectOwner);

        return projectDao.save(project);
    }
}
