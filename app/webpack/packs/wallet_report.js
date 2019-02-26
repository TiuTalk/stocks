import React, { PureComponent } from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import {
  ResponsiveContainer, ComposedChart, Line, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
} from 'recharts';

const WalletReport = props => (
  <div style={{ width: '100%', height: 300 }}>
    <ResponsiveContainer>
      <ComposedChart width={1200} height={350} barCategoryGap="8%" data={props.data}>
        <XAxis dataKey="date" />
        <YAxis />
        <YAxis yAxisId="right" orientation="right" />
        <Tooltip />
        <Legend verticalAlign="top" />
        <CartesianGrid stroke="#f5f5f5" />
        <Bar name="Custo" dataKey="invested" fill="#CE6C47" />
        <Bar name="Valor" dataKey="value" fill="#777DA7" />
        <Line name="CDI" dataKey="cdi" legendType="none" stroke="#E5D352" dot={false} strokeDasharray="5 5" yAxisId="right" unit="%" />
        <Line name="Rentabilidade" dataKey="return_percentage" stroke="#94C949" strokeWidth={2} yAxisId="right" unit="%" />
      </ComposedChart>
    </ResponsiveContainer>
  </div>
)

WalletReport.defaultProps = {
  data: []
}

WalletReport.propTypes = {
  data: PropTypes.array
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('wallet-report-container')
  const data = JSON.parse(node.getAttribute('data'))

  ReactDOM.render(<WalletReport data={data} />, node);
});
