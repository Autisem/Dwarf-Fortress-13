import { useBackend, useLocalState } from '../backend';
import { capitalize } from 'common/string';
import {
  Box,
  Button,
  Divider,
  Flex,
  Section,
  Stack,
  Tabs,
} from '../components';
import { Window } from '../layouts';

export const BuilderHammer = (props, context) => {
  const { act, data } = useBackend(context);
  const { blueprints, activeBlueprint } = data;
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);
  const [bpIndex, setBpIndex] = useLocalState(context, 'bpIndex', -1);
  const [previewOrientation, setPreviewOrientation] = useLocalState(
    context,
    'previewOrientation',
    0
  );
  const activeBlueprintObject = blueprints[tabIndex].blueprints[bpIndex];
  return (
    <Window title="Building Menu" width={756} height={600}>
      <Window.Content>
        <div
          style={{
            height: '100%',
            width: '100%',
            display: 'flex',
          }}>
          <div style={{ 'flex': '1 1', 'margin-right': '6px' }}>
            <div
              style={{
                'display': 'flex',
                'flex-direction': 'column',
                'height': '100%',
              }}>
              <div
                style={{
                  'margin-bottom': '6px',
                }}>
                <Tabs>
                  {blueprints.map((cat, i) => (
                    <Tabs.Tab
                      selected={i === tabIndex}
                      key={cat}
                      onClick={() => {
                        setBpIndex(0);
                        setTabIndex(i);
                      }}>
                      {capitalize(cat.name)}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              </div>
              <div
                style={{
                  'background-color': 'rgba(0,0,0,0.3)',
                  'height': '100%',
                  'padding': '6px',
                }}>
                <div style={{ 'display': 'flex', 'flex-wrap': 'wrap' }}>
                  {blueprints[tabIndex].blueprints.map((bp, i) => (
                    <div
                      key={bp.name}
                      style={{
                        border: `3px solid ${
                          i === bpIndex ? 'gray' : 'transparent'
                        }`,
                      }}>
                      <Button
                        width="80px"
                        height="80px"
                        m="4px"
                        style={{
                          'padding': '0',
                        }}
                        onClick={() => setBpIndex(i)}>
                        <div
                          style={{
                            'position': 'relative',
                            'height': '100%',
                            'width': '100%',
                            'display': 'flex',
                            'flex-direction': 'column',
                            'align-items': 'center',
                          }}>
                          <div
                            style={{
                              'height': '100%',
                              'width': '100%',
                              'display': 'flex',
                              'align-items': 'center',
                              'justify-content': 'center',
                              'padding': '6px',
                            }}>
                            <div
                              style={{
                                'height': '90%',
                                'width': '90%',
                                'background-image': 'url(' + bp.icon + ')',
                                'background-size': 'contain',
                                'background-repeat': 'no-repeat',
                                'background-position': 'center',
                              }}
                            />
                          </div>
                          <div
                            style={{
                              'display': 'flex',
                              'position': 'relative',
                              'max-width': '80px',
                              'top': '-5px',
                            }}>
                            <span
                              style={{
                                'position': 'relative',
                                'text-align': 'center',
                                'white-space': 'normal',
                                'display': 'inline-block',
                                'max-width': '80px',
                                'word-wrap': 'break-word',
                              }}>
                              {capitalize(bp.name)}
                            </span>
                          </div>
                        </div>
                      </Button>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
          <div
            style={{
              'width': '256px',
              'min-width': '256px',
              'height': '100%',
              'background-color': 'rgba(0,0,0,0.3)',
            }}>
            {bpIndex > -1 && (
              <div
                style={{
                  'margin': '0',
                  'height': '100%',
                  'display': 'flex',
                  'flex-direction': 'column',
                  'align-items': 'center',
                  'padding': '8px',
                }}>
                <h1 style={{ 'font-size': '2.2rem' }}>
                  {capitalize(activeBlueprintObject.name)}
                </h1>
                <div
                  style={{
                    'margin': '8px 0',
                    'width': '128px',
                    'height': '128px',
                    'display': 'flex',
                    'justify-content': 'center',
                    'align-items': 'center',
                  }}>
                  <img
                    style={{
                      'height': previewOrientation === 0 ? 'auto' : '100%',
                      'width': previewOrientation === 0 ? '100%' : 'auto',
                      'display': 'block',
                      '-ms-interpolation-mode': 'nearest-neighbor',
                      'image-rendering': 'pixelated',
                    }}
                    src={activeBlueprintObject.icon}
                    onLoad={(e) =>
                      setPreviewOrientation(
                        e.currentTarget.naturalWidth >
                          e.currentTarget.naturalHeight
                          ? 0
                          : 1
                      )
                    }
                  />
                </div>
                <hr
                  style={{
                    'width': '75%',
                    'border-top': '0',
                    'border-color': 'gray',
                  }}
                />
                <div
                  style={{
                    'width': '100%',
                    'text-align': 'center',
                    'margin': '8px 0',
                  }}>
                  {capitalize(activeBlueprintObject.desc)}
                </div>
                <hr
                  style={{
                    'width': '75%',
                    'border-top': '0',
                    'border-color': 'gray',
                  }}
                />
                <h2>Resources</h2>
                <div
                  style={{
                    'flex-grow': '1',
                    'width': '100%',
                  }}>
                  <div
                    style={{
                      'display': 'flex',
                      'flex-direction': 'column',
                    }}>
                    {activeBlueprintObject.reqs.map((req) => (
                      <div
                        key={req}
                        style={{ 'display': 'flex', 'align-items': 'center' }}>
                        <img
                          style={{
                            '-ms-interpolation-mode': 'nearest-neighbor',
                            'image-rendering': 'pixelated',
                          }}
                          src={req.icon}
                        />
                        <span style={{ 'margin-right': '16px' }}>
                          {capitalize(req.name)}
                        </span>
                        <hr
                          style={{
                            'width': '75%',
                            'border-top': '0',
                            'border-color': 'gray',
                            'margin-top': '9px',
                          }}
                        />
                        <span
                          style={{
                            'margin-left': '16px',
                          }}>
                          {`x${req.amount}`}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
                <hr
                  style={{
                    'width': '75%',
                    'border-top': '0',
                    'border-color': 'gray',
                  }}
                />
                <Button
                  style={{
                    'margin-top': '8px',
                    'height': '40px',
                    'width': '128px',
                    'vertical-align': 'center',
                  }}
                  onClick={() =>
                    act('select_blueprint', {
                      path: activeBlueprintObject.path,
                    })
                  }>
                  <div
                    style={{
                      'height': '40px',
                      'display': 'flex',
                      'align-items': 'center',
                      'justify-content': 'center',
                      'padding-bottom': '4px',
                    }}>
                    <span
                      style={{ 'font-weight': '600', 'font-size': '1.2rem' }}>
                      CONFIRM
                    </span>
                  </div>
                </Button>
              </div>
            )}
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
