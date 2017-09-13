import * as React from 'react';
import * as reactDOM from 'react-dom';
import { HashRouter, Route } from 'react-router-dom';
import { Home } from "./home";
import { RouteProps } from "react-router";

reactDOM.render(
    (
        <HashRouter>
            <Route path="/" render={(props:RouteProps)=><Home path={props.location}/>}/>
        </HashRouter>
    ),
    document.getElementById('container')
);