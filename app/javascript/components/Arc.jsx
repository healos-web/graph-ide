import React, { Component } from 'react';
import { Arrow, Group, Line } from 'react-konva';
import Konva from 'konva';
import axios from 'axios';
import Functions from '../utils/Functions'


class Arc extends Component {
  constructor(props) {
    super(props);
    this.state = {
      color: props.arc.color,
      arc_type: props.arc.arc_type,
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
    this.selectTrue = this.selectTrue.bind(this)
  }

  select() {
    this.setState({selected: !this.state.selected});
  }

  selectTrue() {
    this.setState({selected: true})
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

  onMouseDown(evt) {
    evt.cancelBubble = true
  }

  calculDistance(start, finish) {
    return Math.sqrt(Math.pow((finish.x - start.x), 2) + Math.pow((finish.y - start.y), 2))
  }

  calculIndent(x, y, dist, radius){
    return {
      x: (radius * x) / dist,
      y: (radius * y) / dist
    }
  }

  render() {
    const strokeWidth = 6
    const commonArc = "common"
    const radius = 14
    const {startX, startY, finishX, finishY, color, selected, arc_type} = this.state
    const {start_id, finish_id} = this.props.arc
    const distance = this.calculDistance({x: startX, y: startY}, {x: finishX, y: finishY})
    const indent = this.calculIndent(finishX - startX, finishY - startY, distance, radius)
    if (start_id == finish_id) {
      if (arc_type == commonArc)
        var secondArrow = <Arrow
                            points={[finishX + 16, finishY, finishX + 15, finishY]}
                            pointerLength={5}
                            pointerWidth={10}
                            fill={selected ? 'green' : color}
                            stroke={selected ? 'green' : color}
                            strokeWidth={strokeWidth}
                          />
      return <Group onMouseDown={this.onMouseDown} onClick={this.handleClickArc}>
              <Line
                points = {[startX + radius, startY, startX + 30, startY, startX + 30, startY - 30, startX, startY - 45, startX - 30, startY - 30, startX - 30, startY, startX - radius, startY]}//{this.generatePointsForKink({x: startX, y: startY})}
                stroke = {color}
                strokeWidth = {strokeWidth}
                fill={selected ? 'green' : color}
                stroke={selected ? 'green' : color}
                lineCap = 'round'
                lineJoin = 'round'/>
              <Arrow
                points={[finishX - 16, finishY, finishX - 15, finishY]}
                pointerLength={5}
                pointerWidth={10}
                fill={selected ? 'green' : color}
                stroke={selected ? 'green' : color}
                strokeWidth={strokeWidth}
              />
              { secondArrow }
              </Group>
    }
    else { 
      if (arc_type == commonArc)
        var secondArrow = <Arrow
                            points={[-indent.x + finishX, -indent.y + finishY, indent.x + startX, indent.y + startY]}
                            pointerLength={5}
                            pointerWidth={10}
                            fill={selected ? 'green' : color}
                            stroke={selected ? 'green' : color}
                            strokeWidth={strokeWidth}
                          />
      return (
        <Group onMouseDown={this.onMouseDown} onClick={this.handleClickArc}>
          <Arrow
            points={[indent.x + startX, indent.y + startY, -indent.x + finishX, -indent.y + finishY]}
            pointerLength={5}
            pointerWidth={10}
            fill={selected ? 'green' : color}
            stroke={selected ? 'green' : color}
            strokeWidth={strokeWidth}
          />
          { secondArrow }
        </Group>
      );
    }
  }
}

export default Arc;