import * as React from "react";
import { api, User, CatalogItem, CatalogItemType } from "./api";

interface INavbarProps {
    user?: User;
}

export class Navbar extends React.Component<INavbarProps, {}>{
    handleFileUpload = (event:any) => {
        let files = event.target.files
        api.uploadFileAsync(files[0]).then(
            _ => location.reload()
        );
    }

    render(){
        return (
            <header className="nav">
                <div className="container">
                    <div className="nav-left">
                        <div className="nav-item is-paddingless"><h1 className="title">CONTOSO</h1></div>
                    </div>
                    <div className="nav-right nav-menu">
                        <div className="nav-item">
                            <div className="file is-light">
                                <label className="file-label">
                                    <input type="file" className="file-input" onChange={this.handleFileUpload}/>
                                    <span className="file-cta">
                                        <span className="file-icon">
                                            <i className="fa fa-upload"></i>
                                        </span>
                                        <span className="file-label">Upload</span>
                                    </span>
                                </label>
                            </div>
                        </div>
                        <div className="nav-item"><h2 className="subtitle">{this.props.user && this.props.user.DisplayName}</h2></div>
                    </div>
                </div>
            </header>
        );
    }
}