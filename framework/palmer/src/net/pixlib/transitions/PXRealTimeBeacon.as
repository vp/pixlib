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
	import net.pixlib.log.PXStringifier;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	/**
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Cédric Néhémie
	 * @author Francis Bourre
	 */
	final public class PXRealTimeBeacon implements PXTickBeacon
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 * Stores singleton instance.
		 */
		static private var _oI : PXRealTimeBeacon;
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/**
		 * Shape instance where listening ENTER_FRAME event.
		 * 
		 * <p>Shape is not added anywhere in the displaylist.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected const oShape : Shape = new Shape();
		
		/**
		 * EventDispatcher used to broadcast internal event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oED : EventDispatcher;

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var lastTime : Number;

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var pastValues : Vector.<Number>;

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var pastValuesSum : Number;

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected const tickEventType : String = PXTickEvent.TICK;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var speedFactor : Number;

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public var smoothFactor : Number;
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public var maxBias : Number;
		
		/**
		 * @inheritDoc
		 */	
		public function get playing() : Boolean
		{
			return oShape.hasEventListener(Event.ENTER_FRAME);
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns the PXRealTimeBeacon singleton instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXRealTimeBeacon
		{
			if (!(_oI is PXRealTimeBeacon)) 
				_oI = new PXRealTimeBeacon();
			
			return _oI;
		}

		/**
		 * Releases singleton instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function release() : void
		{
			_oI.stop();
			_oI = null;
		}
		
		/**
		 * Creates new instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXRealTimeBeacon( speedFactor : Number = 1, smoothFactor : Number = -1, maxBias : Number = -1 )
		{
			oED = new EventDispatcher();

			this.speedFactor = speedFactor;
			this.smoothFactor = smoothFactor;
			this.maxBias = maxBias;
			this.pastValues = new Vector.<Number>();
			this.pastValuesSum = 0;			
			this.lastTime = getTimer();
		}

		/**
		 * @inheritDoc
		 */	
		public function start() : void
		{
			if( !playing ) oShape.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		/**
		 * @inheritDoc
		 */		
		public function stop() : void
		{
			if( playing ) oShape.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		/**
		 * @inheritDoc
		 */	
		public function addListener( listener : PXTickListener ) : void
		{
			if( !oED.hasEventListener(tickEventType) ) start();
			oED.addEventListener(tickEventType, listener.onTick, false, 0, true);
		}

		/**
		 * @inheritDoc
		 */	
		public function removeListener( listener : PXTickListener ) : void
		{
			oED.removeEventListener(tickEventType, listener.onTick);
			if( !oED.hasEventListener(tickEventType) ) stop();
		}

		/**
		 * Returns the string representation of this object.
		 * 
		 * @return	the string representation of this object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String 
		{
			return PXStringifier.process(this);
		}

		/**
		 * Handles the <code>ENTER_FRAME</code> from the internal
		 * <code>Shape</code> object, and dispatches <code>onTick</code>
		 * event to each listener.
		 * 
		 * @param	e	event dispatched by the Shape object property
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function enterFrameHandler( e : Event ) : void
		{
			var currentTime : Number = getTimer();
			var bias : Number = ( currentTime - lastTime ) * speedFactor;
			
			if( maxBias > 0 ) bias = restrict(bias);
			if( smoothFactor > 0 ) bias = smooth(bias);
			
			oED.dispatchEvent(new PXTickEvent(tickEventType, bias));
			
			lastTime = currentTime;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function smooth( n : Number ) : Number
		{
			pastValues.push(n);
			var length : Number = pastValues.length;
			if( length > smoothFactor )
			{
				pastValuesSum -= Number(pastValues.shift());
				length--;
			}
			pastValuesSum += n;
			
			return pastValuesSum / length;
		}
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function restrict( n : Number ) : Number
		{
			var num : Number = maxBias * speedFactor;
			return n > num ? num : n;
		}
	}
}