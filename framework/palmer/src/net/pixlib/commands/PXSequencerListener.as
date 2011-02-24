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
 
package net.pixlib.commands 
{
	import flash.events.Event;

	/**
	 * Interface for objects which want to be notified of execution 
	 * of a Sequencer.
	 * 
	 * @see PXSequencer
	 * 
	 * @author Romain Ecarnot
	 */
	public interface PXSequencerListener extends PXCommandListener
	{
		/**
		 * Triggered when sequencer starts execution.
		 * 
		 * @param event	ObjectEvent data with sequencer owner as event target 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onSequencerStart( event : Event ) : void;
		
		/**
		 * Triggered when new command is ready to be executed.
		 * 
		 * @param event	ObjectEvent data with sequencer owner as event target 
		 * 				and command ready to be executed 
		 * 				in <code>ObjectEvent.getObject()</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onSequencerProgress( event : Event = null ) : void;
		
		/**
		 * Triggered when sequencer ends execution.
		 * 
		 * <p>Triggered juste before the <code>onCommandEnd</code>.</p>
		 * 
		 * @param event	Event data with sequencer owner as event target
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onSequencerEnd( event : Event ) : void;
	}
}
