import React, { Component} from 'react';

class GoogleMap extends Component {
  mapSrc() {
    const rootUrl = 'http://maps.googleapis.com/maps/api/staticmap';
    const { lat, lng, apiKey, width, height, zoom } = this.props;

    const centerParam = `?center=${lat},${lng}`;
    const keyParam = `&key=${apiKey}`;
    const markersParam = `&markers=${lat},${lng}`;
    const sizeParam =  `&size=${width}x${height}`;
    const zoomParam =  `&zoom=${zoom}`;

    return `${rootUrl}${centerParam}${zoomParam}${sizeParam}${markersParam}${keyParam}`;
  }

  render() {
    return <img src={this.mapSrc()} />
  }
}

export default GoogleMap;
