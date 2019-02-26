import React from 'react';
import PropTypes from 'prop-types';
import {
  ResponsiveContainer, ComposedChart, Line, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
} from 'recharts';

const defaultProps = {
  data: [],
};

const propTypes = {
  data: PropTypes.arrayOf(PropTypes.object),
};

const WalletReport = ({ data }) => (
  <div style={{ width: '100%', height: 300 }}>
    <ResponsiveContainer>
      <ComposedChart width={1200} height={350} barCategoryGap="8%" data={data}>
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
);

WalletReport.propTypes = propTypes;
WalletReport.defaultProps = defaultProps;

export default WalletReport;
