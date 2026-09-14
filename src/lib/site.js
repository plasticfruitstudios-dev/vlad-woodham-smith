// Site identity + structured data, in one place.

export const SITE = 'https://vladws.com';
export const NAME = 'Vlad Woodham-Smith';
export const PFS = { name: 'Plastic Fruit Studios', url: 'https://plasticfruit.co.uk' };

export const abs = (path) => `${SITE}/${path}`;

/** meta description shared by the section pages and most project pages */
export const DEFAULT_DESCRIPTION = 'Vlad Woodham-Smith is a cinematographer based in London, working across music videos, commercials and photography. Work for Sam Smith, Audemars Piguet, Jordan Rakei, Jade, Gorgon City and more.';

/** JSON-LD for the home and info pages */
export const PERSON = {
  '@context': 'https://schema.org',
  '@type': 'Person',
  name: NAME,
  alternateName: 'Vladimir Woodham-Smith',
  jobTitle: 'Cinematographer',
  url: SITE,
  description: 'South London-born cinematographer based in North London, working across music videos, commercials and photography.',
  email: 'vlad@plasticfruitstudios.com',
  address: { '@type': 'PostalAddress', addressLocality: 'London', addressCountry: 'GB' },
  worksFor: { '@type': 'Organization', ...PFS },
  sameAs: ['https://www.instagram.com/vladws', PFS.url],
};
