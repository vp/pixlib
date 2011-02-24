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
	import flash.events.Event;

	/**
	 * A <code>PXTickListener</code> object is an object which will
	 * change in time according to the <code>PXTickBeacon</code> it
	 * listen. A <code>TickListener</code> object is considered as
	 * playing only if it is registered as listener of a beacon, even
	 * if this beacon is not currently playing. It offers to the user
	 * two ways to handle interruption of animations within an 
	 * application, all objects could be paused or resume with a single
	 * call to the <code>start</code> or <code>stop</code> methods of a
	 * beacon, or they could be individually paused or resume by calling
	 * the corresponding methods onto the listeners themselves.
	 * <p>
	 * Concret implementation should provide methods which automatically
	 * register on unregister the object as listener of the specified beacon.
	 * </p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 * @author 	Cédric Néhémie
	 * @see		TickBeacon
	 */
	public interface PXTickListener 
	{
		/**
		 * Method called on each iteration according to <code>PXTickBeacon</code>
		 *  time slicing approach.
		 * <p>
		 * The <code>onTick</code> method is very similar to the
		 * old <code>onEnterFrame</code> method, but doesn't specifically
		 * occurs when entering in a new frame of a frame-based animation.
		 * The tick could be the result of a <code>setInterval</code> call, 
		 * or position change in a video's timecode...
		 * </p> 
		 * @param	e	event dispatched by beacon object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		function onTick( event : Event = null ) : void;
	}
}