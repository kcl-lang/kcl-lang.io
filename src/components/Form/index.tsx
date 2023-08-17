'use client';
// Reference: https://github.com/bytebase/bytebase.com/tree/main/src/components/shared/subscription/form/form.tsx

import React from 'react';
import { useCallback, useState } from 'react';
import clsx from 'clsx';
import Translate from '@docusaurus/Translate';

const EMAIL_REGEX =
    // eslint-disable-next-line no-control-regex, no-useless-escape
    /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i;

const STATES = {
    DEFAULT: 'default',
    ERROR: 'error',
    LOADING: 'loading',
    SUCCESS: 'success',
};

const ErrorMessage = ({ className, message }: { className?: string; message: string }) => (
    <div className={clsx('remove-autocomplete-styles flex-grow rounded-l-full px-7 py-6 text-16 leading-none tracking-tight placeholder-gray-40 outline-none transition-colors duration-200 disabled:bg-white xl:px-5 xl:py-4 sm:px-5', className)}>
        <div className="text--center relative flex rounded-lg border border-secondary-6 bg-[#b14747] px-3.5 py-3 text-14 leading-tight tracking-tight text-secondary-6 shadow-[0px_0px_30px_rgba(0,0,0,0.2)] ">
            <span>{message}</span>
        </div>
    </div>
);

const WIDTH = 180;
const HEIGHT = 70;

function SubscribeSection() {
    return <section>
        <div className="container text--center">
            <h2
                className={clsx(
                    "text--center",
                )}
                style={{ color: "var(--ifm-color-primary)" }}
            >
                <Translate>Subscribe to Newsletter</Translate>
            </h2>
            <div className="container text--center">
                <form action="https://kcl-lang.us21.list-manage.com/subscribe/post?u=058fb980b248a836995b4c09a&amp;id=05b7eecfe9&amp;f_id=007e2fe7f0" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" className="validate" target="_self">
                    <div aria-hidden="true" style={{ position: "absolute", left: "-5000px" }}>
                        <input type="email" name="b_058fb980b248a836995b4c09a_05b7eecfe9" value="" />
                    </div>
                    <input
                        className={clsx(
                            'remove-autocomplete-styles flex-grow rounded-l-full px-7 py-6 text-16 leading-none tracking-tight placeholder-gray-40 outline-none transition-colors duration-200 disabled:bg-white xl:px-5 xl:py-4 sm:px-5 text-gray-15',
                        )}
                        type="email"
                        name="EMAIL"
                        autoComplete="email"
                        placeholder="Your email address..."
                        style={{ width: 300 }}
                    />
                    <button
                        aria-label="Subscribe"
                        className={clsx(
                            'trans flex-shrink-0 rounded-r-full bg-center bg-no-repeat px-11 py-6 text-16 font-bold uppercase leading-none transition-colors duration-200 xl:py-4 md:px-5 md:py-3 sm:px-5 sm:py-3',
                            {
                                'pointer-events-none': false,
                            },
                        )}
                        type="submit"
                    >
                        <span
                            className={clsx({
                                'opacity-0': false,
                            })}
                        >
                            <Translate>Subscribe</Translate>
                        </span>
                    </button>
                </form>
            </div>
        </div>
    </section>
}

export const Form = ({ fireInput }: { fireInput?: () => void }) => {
    const [email, setEmail] = useState('');
    const [formState, setFormState] = useState(STATES.DEFAULT);

    const [errorMessage, setErrorMessage] = useState('');

    const onChange = useCallback(
        (event: React.ChangeEvent<HTMLInputElement>) => {
            fireInput && fireInput();
            setFormState(STATES.DEFAULT);
            const value = event.currentTarget.value.trim();
            setEmail(value);
            if (!value) {
                setErrorMessage('Please enter your email');
                setFormState(STATES.ERROR);
                return;
            }

            if (!EMAIL_REGEX.test(value)) {
                setErrorMessage('Please enter a valid email');
                setFormState(STATES.ERROR);
                return;
            }
            setFormState(STATES.DEFAULT);
        },
        [fireInput],
    );

    const onSubmit = useCallback(
        async (evt: React.FormEvent<HTMLFormElement>) => {
            evt.preventDefault();

            if (!email) {
                setErrorMessage('Please enter your email');
                setFormState(STATES.ERROR);
                return;
            }

            if (!EMAIL_REGEX.test(email)) {
                setErrorMessage('Please enter a valid email');
                setFormState(STATES.ERROR);
                return;
            }

            setFormState(STATES.LOADING);
            setErrorMessage('');

            try {
                await fetch('https://kcl-lang.us21.list-manage.com/subscribe/post?u=058fb980b248a836995b4c09a&amp;id=05b7eecfe9&amp;f_id=007e2fe7f0', {
                    method: 'POST',
                    body: JSON.stringify(email),
                });

                setTimeout(() => {
                    setFormState(STATES.SUCCESS);
                    setEmail('Thank you for subscribing!');

                    setTimeout(() => {
                        setFormState(STATES.DEFAULT);
                        setEmail('');
                    }, 5000);
                }, 5200);
            } catch (error: any) {
                setFormState(STATES.ERROR);
                setErrorMessage(error?.message ?? error);
            }
        },
        [email],
    );

    return (
        <form className="text-white container text--center" action="https://kcl-lang.us21.list-manage.com/subscribe/post?u=058fb980b248a836995b4c09a&amp;id=05b7eecfe9&amp;f_id=007e2fe7f0" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" className="validate" target="_self">
            <div aria-hidden="true" style={{ position: "absolute", left: "-5000px" }}>
                <input type="email" name="b_058fb980b248a836995b4c09a_05b7eecfe9" value="" />
            </div>
            <input
                className={clsx(
                    'remove-autocomplete-styles flex-grow rounded-l-full px-7 py-6 text-16 leading-none tracking-tight placeholder-gray-40 outline-none transition-colors duration-200 disabled:bg-white xl:px-5 xl:py-4 sm:px-5',
                    formState === STATES.ERROR ? 'text-secondary-6' : 'text-gray-15',
                )}
                type="email"
                name="EMAIL"
                autoComplete="email"
                value={email}
                placeholder="Your email address..."
                disabled={formState === STATES.LOADING || formState === STATES.SUCCESS}
                onChange={onChange}
                style={{ maxWidth: WIDTH, minHeight: HEIGHT }}
            />
            <button
                aria-label="Subscribe"
                className={clsx(
                    'trans flex-shrink-0 rounded-r-full bg-center bg-no-repeat px-11 py-6 text-16 font-bold uppercase leading-none transition-colors duration-200 xl:py-4 md:px-5 md:py-3 sm:px-5 sm:py-3',
                    {
                        'bg-[length:40px_40px] xl:bg-[length:28px_28px]':
                            formState === STATES.LOADING,
                        'bg-[length:32px_32px] xl:bg-[length:24px_24px]':
                            formState === STATES.SUCCESS,
                        'pointer-events-none': formState === STATES.LOADING || formState === STATES.SUCCESS,
                    },
                )}
                type="submit"
                style={{ width: WIDTH, minHeight: HEIGHT }}
            >
                <span
                    className={clsx({
                        'opacity-0': false,
                    })}
                >
                    <Translate>Subscribe</Translate>
                </span>
            </button>
            <ErrorMessage
                className={clsx(
                    formState === STATES.ERROR
                        ? 'pointer-events-auto visible opacity-100'
                        : 'pointer-events-auto invisible opacity-100',
                )}
                message={errorMessage}
            />

        </form>
    );
};
