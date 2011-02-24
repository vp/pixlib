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
package net.pixlib.log
{
	import net.pixlib.events.PXEventChannel;
	
	/**
	 * Adds a new PXLogListener instance as new Logging API layout.
	 * 
	 * <p>This method is a just a shortcut to PXLogManager#addLogListener() 
	 * method.</p>
	 * 
	 * @param 	listener	PXLogListener instance
	 * @param	channel		event channel for which the listener listen 
	 * 
	 * @see PXLogManager
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public function addLogListener(listener : PXLogListener, channel : PXEventChannel = null) : void 
	{
		PXLogManager.getInstance().addLogListener(listener, channel);
	}
}
