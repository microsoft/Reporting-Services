import * as React from 'react';
import { api, CatalogItem, CatalogItemType, User } from "./api";
import { Link } from "react-router-dom";
import * as moment from 'moment';
import { Navbar } from "./navbar";

interface IHomeState {
    items?: CatalogItem[],
    user?: User,
    path: string
}

export class Home extends React.Component<any,IHomeState> {

    constructor(){
        super();
        this.state = { path:'/' };
    }

    componentDidMount(){
        api.meAsync().then((user:User)=>this.setState({user}));
        api.getFolderItemsAsync().then((items:CatalogItem[]) => this.setState({items:items.sort((a,b)=>a.Type.localeCompare(b.Type))}));
    }

    componentWillReceiveProps(props:any){
        this.setState({path:props.path.pathname, items:undefined});
        api.getFolderItemsAsync(props.path.pathname)
            .then((items:CatalogItem[]) => this.setState({items:items.sort((a,b)=>a.Type.localeCompare(b.Type))}));
    }

    render() {
        if(!this.state.items)
            return (
                <section className="hero is-warning is-fullheight">
                    <div className="hero-head">
                        <Navbar user={this.state.user}/>
                    </div>
                    <div className="hero-body">
                        <div className="container has-text-centered"><h1 className="title">Loading Items...</h1></div>
                    </div>
                </section>
            );
        
        return (
            <div>
                <section className="hero is-warning is-small">
                    <div className="hero-head">
                        <Navbar user={this.state.user}/>
                    </div>
                    <div className="hero-body">
                        <div className="container">
                            <h1 className="title">
                                Reports
                            </h1>
                        </div>
                    </div>
                </section>
                <section className="section">
                    <div className="container">
                        <BreadCrumb path={this.state.path} />
                        <div className="columns is-multiline">
                            {this.state.items.map( (item:CatalogItem) => <CatalogItemTile item={item}/>)}
                        </div>
                    </div>
                </section>
            </div>
        )
    }
}

let CatalogItemTile:React.SFC<{item:CatalogItem}> = ({item}) => {
    let tagColor;

    switch(item.Type){
        case CatalogItemType.Report:
            tagColor = 'is-danger';
            break;
        case CatalogItemType.PowerBIReport:
            tagColor = 'is-warning';
            break;
        case CatalogItemType.Folder:
            tagColor = 'is-info';
            break;
        default:
            tagColor = 'is-primary';
            break;
    }

    return (
        <div className="column is-3">
            <div className="card">
                <div className="card-content">
                    <div className="content">
                        {item.Type === CatalogItemType.Folder ? <Link to={item.Path || '/'}>{item.Name}</Link> : <strong>{item.Name}</strong>}<br/>
                        {item.Description}<br/>
                        <small>@{item.ModifiedBy}</small><br/>
                        <small>{moment(item.ModifiedDate).format('lll')}</small><br/>
                        <div className={`tag ${tagColor}`}>{item.Type.toUpperCase()}</div>
                    </div>
                </div>
            </div>
        </div>
    )
}

let BreadCrumb:React.SFC<{path:string}> = ({path}) => {
    let parts = path.substring(1).split('/');
    return (
        <nav className="breadcrumb is-large" aria-label="breadcrumbs">
            <ul>
                <li><Link to="/">Home</Link></li>
                {path.length > 1 && parts.map((part, idx) => <li><Link to={"/"+parts.slice(0,idx+1).join('/')}>{part}</Link></li>)}
            </ul>
        </nav>
    )
}