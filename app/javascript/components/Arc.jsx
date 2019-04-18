import React, { Component } from 'react';
import { Arrow } from 'react-konva';
import Konva from 'konva';
import axios from 'axios';
import Functions from '../utils/Functions'


class Arc extends Component {
  constructor(props) {
    super(props);
    this.state = {
      color: props.arc.color,
      arc_type: props.arc_type,
      startX: parseFloat(props.arc.start_x),
      startY: parseFloat(props.arc.start_y),
      finishX: parseFloat(props.arc.finish_x),
      finishY: parseFloat(props.arc.finish_y),
      id: props.arc.id,
      selected: false
    };
    this.handleClickArc = this.handleClickArc.bind(this)
    this.select = this.select.bind(this)
    this.changeStartCoordinates = this.changeStartCoordinates.bind(this)
    this.changeFinishCoordinates = this.changeFinishCoordinates.bind(this)
    this.checkBounds = this.checkBounds.bind(this) 
  }

  select() {
    this.setState({selected: !this.state.selected});
  }

  checkBounds(pos) {
    const { width, height } = this.props
    var newY = pos.y > height - 20 ? height - 20 : pos.y
    var newX = pos.x > width - 15 ? width - 15 : pos.x
    newY = newY > 20 ? newY : 20
    newX = newX > 20 ? newX : 20
    return {
      x: newX,
      y: newY
    };
  }

  changeStartCoordinates(newStartX, newStartY) {
    this.setState({startX: newStartX, startY: newStartY})
  }

  changeFinishCoordinates(newFinishX, newFinishY) {
    this.setState({finishX: newFinishX, finishY: newFinishY})
  }

  handleClickArc(evt) {
    this.props.select(this.props.arc)
    evt.cancelBubble = true
  };

  calculDistance(start, finish) {
    return Math.sqrt(Math.pow((finish.x - start.x), 2) + Math.pow((finish.y - start.y), 2))
  }

  calculIndent(x, y, dist, radius){
    return {
      x: radius*x/dist,
      y: radius*y/dist
    }
  }

  render() {
    const radius = 14
    const { startX, startY, finishX, finishY, color, selected} = this.state
    const distance = this.calculDistance({x: startX, y: startY}, {x: finishX, y: finishY})
    const indent = this.calculIndent(finishX - startX, finishY - startY, distance, radius)
    return (
      <Arrow
        onClick={this.handleClickArc}
        points={[indent.x + startX, indent.y + startY, -indent.x + finishX, -indent.y + finishY]}
        pointerLength={5}
        pointerWidth={10}
        fill={selected ? 'green' : color}
        stroke={selected ? 'green' : color}
        strokeWidth={6}
      />
    );
  }
}

export default Arc;