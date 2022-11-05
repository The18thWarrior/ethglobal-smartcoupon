import { LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import ethersScript from '@salesforce/resourceUrl/web3';
 
export default class CouponModule extends LightningElement {
  connectedCallback() {
    
    loadScript(this, ethersScript).then((res) => {
      console.log('script loaded');
       try {
        console.log(window);
        console.log(ethersScript);
        //console.log(Web3);
       } catch (err) {
        console.log('error',err);
       }
    });
  }

  renderedCallback() {
    console.log(window.Web3);
  }
}