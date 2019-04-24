import React, { Component } from 'react';
import { Stage, Layer, Rect, Text } from 'react-konva';
import Node from './Node'
import Arc from './Arc'
import Functions from '../utils/Functions'
import axios from "axios";

class CanvasArea extends Component {
  constructor(props) {
    super(props);
    this.state = {
      nodes: props.nodes,
      arcs: props.arcs,
      selected: {nodes: [], arcs: []},
      selectRect: false,
      rectX: 1,
      rectY: 1,
      rectWidth: 0,
      rectHeight: 0
    };

    this.select = this.select.bind(this)
    this.handleClick = this.handleClick.bind(this)
    this.handleDoubleClick = this.handleDoubleClick.bind(this)
    this.sendSelectedItems = this.sendSelectedItems.bind(this)
    this.moveArc = this.moveArc.bind(this)
    this.handleOnMouseDown = this.handleOnMouseDown.bind(this)
    this.handleOnMouseUp = this.handleOnMouseUp.bind(this)
    this.handleOnMouseMove = this.handleOnMouseMove.bind(this)
    this.selectUnderRect = this.selectUnderRect.bind(this)
  }

  handleClick = (event) => {
    if (!this.state.selectRect) {
      const selected = this.state.selected
      const refs = this.refs
      selected.nodes.forEach((node)=>{
        eval("refs.Node" + node.id + ".select()");
      })
      selected.arcs.forEach((arc) => {
        eval("refs.Arc" + arc.id + ".select()");
      })
      this.setState({selected: {nodes: [], arcs: []}})
      this.sendSelectedItems()
    }
    else
      this.setState({selectRect: false})
  };

  handleDoubleClick = (event) => {
    const x = event.evt.layerX
    const y = event.evt.layerY
    $.ajax({
      type: 'POST',
      url: 'graphs/' + this.props.graph_id + '/nodes',
      data: { node: { x: x, y: y },
              authenticity_token: Functions.getMetaContent("csrf-token")
            }
    })
  }

  handleOnMouseUp(event) {
    const { rectWidth, rectHeight} = this.state
    if (rectWidth > 0 || rectHeight > 0) {
      this.selectUnderRect()
      this.setState({ rectWidth: 0, rectHeight: 0})
    }
    else
      this.setState({selectRect: false})
  }

  handleOnMouseDown(event) {
    this.setState({selectRect: true, rectX: event.evt.layerX, rectY: event.evt.layerY })
  }

  handleOnMouseMove(event) {
    const {rectHeight, rectWidth} = this.state
    if (this.state.selectRect)
      this.setState({ rectHeight: rectHeight + event.evt.movementY, rectWidth: rectWidth + event.evt.movementX })
  }

  selectUnderRect() {
    const {selected, nodes, arcs, rectWidth, rectHeight, rectX, rectY} = this.state
    const pointArea1 = {x: rectX, y: rectY}
    const pointArea2 = {x: rectX + rectWidth, y: rectY + rectHeight}
    const inArea = this.inArea
    const refs = this.refs

    nodes.map((node)=>{
      if (inArea({x: node.x, y: node.y}, pointArea1, pointArea2)){
        eval("refs.Node" + node.id + ".selectTrue()");
        selected.nodes.push(node)
      }
    })
    arcs.map((arc) => {
      if (inArea({x: arc.start_x, y: arc.start_y}, pointArea1, pointArea2) || inArea({x: arc.finish_x, y: arc.finish_y}, pointArea1, pointArea2)) {     
        eval("refs.Arc" + arc.id + ".selectTrue()");
        selected.arcs.push(arc)
      }
    })
    this.setState({selected: selected})
    this.sendSelectedItems()
  }

  inArea(point, pointArea1, pointArea2) {
    return point.x > pointArea1.x && point.x < pointArea2.x && point.y > pointArea1.y && point.y < pointArea2.y
  }

  moveArc(id, x, y) {
    const arcs = this.state.arcs
    const refs = this.refs
    arcs.forEach( (arc) => {
      if (arc.start_id == id)
        eval("refs.Arc" + arc.id + ".changeStartCoordinates(x, y)");
      if (arc.finish_id == id)
        eval("refs.Arc" + arc.id + ".changeFinishCoordinates(x, y)");
    })
  }

  sendSelectedItems() {
    let nodes = JSON.stringify(this.state.selected.nodes)
    let arcs = JSON.stringify(this.state.selected.arcs)
    $.ajax({
      type: 'POST',
      url: 'graphs/' + this.props.graph_id + '/selected_elements',
      data: { nodes: nodes,
              arcs: arcs,
              authenticity_token: Functions.getMetaContent("csrf-token")
            }
    })
  }

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
      eval("this.refs.Arc" + object.id + ".select()");
    }
    this.sendSelectedItems()
  }

  render() {
    const parent = document.getElementById('working_area')
    const {rectX, rectY, rectWidth, rectHeight, nodes, arcs} = this.state
    // Stage is a div container
    // Layer is actual canvas element (so you may have several canvases in the stage)
    // And then we have canvas shapes inside the Layer
    return (
      <Stage 
        onDblClick={this.handleDoubleClick}
        onClick={this.handleClick}
        width={parent.clientWidth}
        height={parent.clientHeight}
        onMouseDown={this.handleOnMouseDown}
        onMouseUp={this.handleOnMouseUp}
        onMouseMove={this.handleOnMouseMove}>
        <Layer>
          <Rect x={rectX} 
                y={rectY}
                width={rectWidth}
                height={rectHeight}
                strokeEnabled={false}
                fill={'blue'}
                opacity={0.75}/>
            { nodes.map(node => (
              <Node key={node.id}
                    ref={"Node" + node.id}
                    moveArc={this.moveArc}
                    node={node}
                    width={parent.clientWidth}
                    height={parent.clientHeight}
                    select={this.select}/>
            )) }
            { arcs.map(arc => (
              <Arc key={arc.id}
                    ref={"Arc" + arc.id}
                    arc={arc}
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