import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { AppComponent } from './app.component';
import { ProjectDataService } from "./services/project-data.service";
import { ProjectListHeaderComponent } from './project-list-header/project-list-header.component';
import { ProjectFormComponent } from './project-form/project-form.component';
import { PaginationComponentComponent } from './pagination-component/pagination-component.component';
import { ProjectListComponent } from './project-list/project-list.component';
import { ProjectListEntryComponent } from './project-list/project-list-entry/project-list-entry.component';
import { LoaderComponent } from './shared/loader/loader.component';
import { ProjectGridComponent } from './project-grid/project-grid.component';
import { ProjectGridEntryComponent } from './project-grid/project-grid-entry/project-grid-entry.component';
import { AgGridModule } from "ag-grid-angular/main";
import { UiSwitchModule } from '../../node_modules/angular2-ui-switch/src';
import { RepositoryDataService } from "./services/repository-data.service";
import { RepoSwitchComponent } from './repo-switch-list/repo-switch/repo-switch.component';
import { RepoSwitchListComponent } from './repo-switch-list/repo-switch-list.component';
import { BrokenBuildDataService } from "./services/broken-build.service";
import { ProjectsPageComponent } from './projects-page/projects-page.component';
import { routes } from './app.router';
import { HomePageComponent } from './home-page/home-page.component';


@NgModule({
  declarations: [
    AppComponent,
    ProjectListHeaderComponent,
    ProjectFormComponent,
    PaginationComponentComponent,
    ProjectListComponent,
    ProjectListEntryComponent,
    LoaderComponent,
    ProjectGridComponent,
    ProjectGridEntryComponent,
    RepoSwitchComponent,
    RepoSwitchListComponent,
    ProjectsPageComponent,
    HomePageComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    UiSwitchModule,
    routes,
    AgGridModule.withComponents(
      [ProjectGridEntryComponent]
    )
  ],
  providers: [ProjectDataService, RepositoryDataService, BrokenBuildDataService],
  bootstrap: [AppComponent]
})
export class AppModule { }
