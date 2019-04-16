import React, { Component } from 'react';
import { Stage, Layer, Rect, Text } from 'react-konva';
import Node from './Node'
import Arc from './Arc'
import Konva from 'konva';

class CanvasArea extends Component {
  constructor(props) {
    super(props);
    this.state = {
      nodes: props.nodes,
      arcs: props.arcs,
      selected: {nodes: [], arcs: []}
    };

    this.select = this.select.bind(this)
    this.handleClick = this.handleClick.bind(this)
  }

  handleClick = (event) => {
    console.log(event)
    console.log(2)
    let selected = this.state.selected
    let refs = this.refs
    selected.nodes.forEach((node)=>{
      eval("refs.Node" + node.id + ".select()");
    })
    selected.arcs.forEach((arc) => {
      eval("refs.Arc" + arc.id + ".select()");
    })
    this.setState({selected: {nodes: [], arcs: []}})
  };

  select(object) {
    let selected = this.state.selected
    let index
    if (object.name) {
      index = selected.nodes.indexOf(object)
      index == -1 ? selected.nodes.push(object) : selected.nodes.splice(index, 1)
      eval("this.refs.Node" + object.id + ".select()");
    }
    else {
      index = selected.arcs.indexOf(object)
      index == -1 ? selected.arcs.push(object) : selected.arcs.splice(index, 1)
    }
  }

  render() {
    const parent = document.getElementById('working_area')
    const { nodes, arcs} = this.state
    // Stage is a div container
    // Layer is actual canvas element (so you may have several canvases in the stage)
    // And then we have canvas shapes inside the Layer
    return (
      <Stage  onClick={this.handleClick} width={parent.clientWidth} height={parent.clientHeight}>
        <Layer  >
            { nodes.map(node => (
              <Node key={node.id}
                    ref={"Node" + node.id}
                    node={node}
                    width={parent.clientWidth}
                    height={parent.clientHeight}
                    select={this.select}/>
            )) }
        </Layer>
      </Stage>
    );
  }
}

export default CanvasArea;