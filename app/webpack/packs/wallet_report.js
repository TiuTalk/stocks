import React from 'react';
import ReactDOM from 'react-dom';
import WalletReport from '../components/WalletReport';

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('wallet-report-container');
  const data = JSON.parse(node.getAttribute('data'));

  ReactDOM.render(React.createElement(WalletReport, { data }), node);
});
