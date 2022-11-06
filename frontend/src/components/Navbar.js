// import { ConnectButton } from "@rainbow-me/rainbowkit";
import styles from "../styles/Navbar.module.css";
import logo from '../images/salogo.png'

export default function Navbar() {
    return (
        <div className={styles.navbar}>
            <center><a href="/"><img src={logo} alt="My Logo" width="25%" height="25%"></img></a></center>
            {/* <ConnectButton/> */}
            
        </div>
    );
}