import React, { Component } from 'react';
import { Group, Text, Circle } from 'react-konva';
import Konva from 'konva';
import axios from 'axios';
import Functions from '../utils/Functions'


class Node extends Component {
  constructor(props) {
    super(props);
    this.state = {
      name: props.node.name,
      x: props.node.x,
      y: props.node.y,
      color: props.node.color,
      id: props.node.id,
      isDraggable: false,
      selected: false
    };
    this.onDragStart = this.onDragStart.bind(this)
    this.onDragEnd = this.onDragEnd.bind(this)
    this.dragBoundFunc = this.dragBoundFunc.bind(this)
    this.handleClickNode = this.handleClickNode.bind(this)
  }

  select() {
    this.setState({selected: !this.state.selected});
  }

  handleClickNode(evt) {
    this.props.select(this.props.node)
    evt.cancelBubble = true
  };

  onDragStart = () => {
    this.setState({
      isDraggable: true
    })
  }

  onDragEnd = e => {
    const x = e.target.x()
    const y = e.target.y()
    this.setState({
      isDraggable: false,
      x: x,
      y: y
    })
    axios.patch('nodes/' + this.state.id, { 
      node: {x: x, y: y},
      authenticity_token: Functions.getMetaContent("csrf-token")
    })
  }

  dragBoundFunc = (pos) => {
    const { width, height } = this.props
    var newY = pos.y > height - 20 ? height - 20 : pos.y
    var newX = pos.x > width - 15 ? width - 15 : pos.x
    newY = newY > 20 ? newY : 20
    newX = newX > 20 ? newX : 20
    this.props.moveArc(this.state.id, newX, newY)
    return {
      x: newX,
      y: newY
    };
  }

  render() {
    const radius = 12
    const strokeWidth = 4
    const { name, x, y, color, selected, isDraggable} = this.state
    return (
      <Group
        x={parseFloat(x)}
        y={parseFloat(y)}
        draggable
        onDragStart={this.onDragStart}
        onDragEnd={this.onDragEnd}
        //onDragMove={this.onDragMove}
        dragBoundFunc={this.dragBoundFunc}
        onClick={this.handleClickNode}>
        <Circle
          radius={radius}
          strokeEnabled={true}
          strokeWidth={strokeWidth}
          stroke={selected || isDraggable ? 'green' : color}/>
        <Text 
          fontSize = {15}
          fontFamily = 'Calibri'
          text = {name}
          fill = 'black'
          padding = {12} />
      </Group>
    );
  }
}

export default Node;