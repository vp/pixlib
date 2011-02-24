/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.pixlib.transitions
{

	/**
	 * A <code>PXTickBeacon</code> object is an object which provides
	 * time slicing in an application. Many objects such tweens or
	 * timed commands plug themselves on a beacon to be notified 
	 * of time changes.
	 * <p>
	 * The tick is the atomic unit of computation, it corresponds to
	 * a step of computation in an animation. Its an equivalent to
	 * the frame unit, but, rather than using the frame as unit, which
	 * is more suitable for timeline based animation, we choose to use
	 * the tick, which is a more generic notation.
	 * </p><p>
	 * Each concret implemetation or instance of beacon could have a different
	 * atomic time entity, with different scale. For example a beacon can work
	 * with the flash player <code>ENTER_FRAME</code> event, with a framerate
	 * set to <code>40</code>, and in parallel there could be two others 
	 * beacons, working with the <code>setInterval</code> function and with step
	 * respectively set to <code>10ms</code> and <code>100ms</code>.
	 * </p><p>
	 * The main contract defined by this interface is that all time beacons
	 * objects should register and unregister as many listeners as needed.
	 * These listeners will be notified of time changes only if the beacon
	 * is currently running (according to the <code>playing</code> return).
	 * Each listener must implement <code>PXTickListener</code> interface.
	 * </p><p>
	 * Concret implementation of <code>PXTickBeacon</code> should take care of 
	 * not registering twice an object, in order to prevent time scale breaks.
	 * </p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author	Francis Bourre
	 * @author	Cédric Néhémie
	 * @see		TickListener
	 */
	public interface PXTickBeacon
	{
		/**
		 * Returns <code>true</code> if this beacon object is currently
		 * running.
		 * 
		 * @return	<code>true</code> if this beacon object is currently
		 * 			running
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get playing() : Boolean;
		
		/**
		 * Adds the passed-in <code>listener</code> as listener for
		 * this <code>PXTickBeacon</code>. Concret implementations should
		 * start themselves when a first listener is added. That behavior
		 * ensure that there's no running beacon which have no listeners
		 * registered. It also guarantee that an object will immediatly
		 * run when it add itself as listener.
		 * <p>
		 * Concret implementation should not register an object which was
		 * already a listener of this beacon.
		 * </p> 
		 * 
		 * @param	listener	tick listener to be added
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function addListener( listener : PXTickListener ) : void;
		
		/**
		 * Removes the passed-in listener from listening for this beacon's
		 * event.  Concret implementations should stop themselves when the
		 * last listener is removed. That behavior ensure that there's no
		 * running beacon which have no listeners registered.
		 * 
		 * @param	listener	tick listener to be removed
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function removeListener( listener : PXTickListener ) : void;		

		/**
		 * Starts this beacon if it wasn't already nunning.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function start() : void;		

		/**
		 * Stops this beacon if it wasn't already stopped.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function stop() : void;		
	}
}